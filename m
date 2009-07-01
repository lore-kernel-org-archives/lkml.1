Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZGAW5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZGAW5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbZGAW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:57:44 -0400
Received: from mail.crca.org.au ([67.207.131.56]:59941 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZGAW5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:57:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4A4BEA25.3000605@crca.org.au>
Date: Thu, 02 Jul 2009 08:58:45 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeremy Maitin-Shepard <jeremy@jeremyms.com>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
 encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <200907011755.10386.rjw@sisk.pl> <874otw15r6.fsf@jeremyms.com> <200907020041.52198.rjw@sisk.pl>
In-Reply-To: <200907020041.52198.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Rafael J. Wysocki wrote:
> On Wednesday 01 July 2009, Jeremy Maitin-Shepard wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>>> [snip]
>>>> As far as the possibility of using uswsusp goes, I'd like to get
>>>> Rafael's input there - he knows it much better than I do (explicitly
>>>> adding him to the ccs).
>>> No, the current mainline hibernation code can't be modified easily
>>> to encrypt the page cache before suspending.
>>> Also, I don't see much value in doing that before suspend to RAM, because
>>> (1) passwords and encryption keys should be stored in mlocked memory
>> I do not have a complete understanding of linux memory management, but
>> couldn't such memory also be included in the encryption?  The page cache
>> is presumably the bulk of memory, but I realize there are likely several
>> other places in memory that may contain sensitive data.  However, it
>> would seem that encrypting these in place should, for the most part,
>> also be quite feasible.
> 
> What is the particular attach scenario you'd like to prevent
> 
>>> and (2)
>>> the encryption overhead (including measures to protect the encrypted page cache
>>> from being corrupted) would hurt the speed of suspend to RAM and resume, which
>>> is a very important thing.
>> I am not suggesting that it be done unconditionally.  I am simply
>> suggesting that it be made available as an option, just as hibernating
>> to encrypted swap is an option, and using dm-crypt in general is an
>> option.  Surely encrypting and decrypting would take additional time,
>> but it would also surely take far less time than hibernating and
>> resuming.  On machines with hardware encryption support (such as the
>> future Intel Westmere processor), encrypting several gigabytes of memory
>> may not take very much time at all.
>>
>>> Moreover, I don't really see how we can feed the decryption key to the
>>> kernel during resume before the page cache can be accessed.
>> My understanding is that this is something that is already done in
>> tuxonice.  After the contents of the page cache are written to disk,
>> some of the page cache is overwritten with a copy of the rest of memory,
>> and the kernel continues to interact with the userspace UI program.  I
>> would assume that this state is effectively equivalent to the state the
>> system would be in after encrypting the page cache.  (Obviously the
>> memory needed by the userspace helper would have to be treated
>> specially.)
> 
> There's one problem with this approach, which is that we're not sure if the
> encrypted pages won't be written to by someone else.  TuxOnIce makes the
> assumption that it won't, but that has yet to be demonstrated.

I can think of a couple of things that can be done here:

- Checksum the pages and verify the data hasn't changed.
- Unmap pages as they're compressed, so that any unexpected usage is caught.

Do you have any other ideas?

Regards,

Nigel
