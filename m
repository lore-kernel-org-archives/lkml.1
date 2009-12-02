Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZLBB6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZLBB6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZLBB6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:58:46 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:41786 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZLBB6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:58:46 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200912011328.15551.rjw@sisk.pl>
	<877ht68u4h.fsf@tac.ki.iif.hu> <200912012232.50951.rjw@sisk.pl>
Date: Wed, 02 Dec 2009 02:58:41 +0100
In-Reply-To: <200912012232.50951.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 1 Dec 2009 22:32:50 +0100")
Message-ID: <87638qw2zy.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 01 December 2009, Ferenc Wagner wrote:
>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>>> On Tuesday 01 December 2009, Ferenc Wagner wrote:
>>>
>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>
>>>>> In addition to that, you can run multiple hibernation/resume cycles in
>>>>> a tight loop using the RTC wakealarm.
>>>> 
>>>> I'll do so, as soon as I find a way to automatically supply the dm-crypt
>>>> passphrase... or even better, learn to hibernate to ramdisk from the
>>>> initramfs. :)
>>>
>>> Well, you don't need to use swap encryption for _testing_. :-)
>> 
>> I use partition encryption, everything except for /boot is encrypted.
>
> If /boot is big enough, you could use a swap file in /boot for the testing.

Ramdisk worked good.  Maybe too good, because I left the machine doing
s2disks while I was having dinner, and it achieved some 120 suspends
without a freeze.  Only the e100 and the mii modules were loaded.

After some script munging I got the machine automatically boot with an
alternate passphrase, so in vivo testing is possible now.  I mean,
tomorrow.

Btw. s2disk has a strange effect of simulating enters during suspend.
It looks like this in a terminal:

$ sudo s2disk



















$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ 
$ <cursor is here>

Can you also see this?

>> Apropos: does s2disk perform encryption with a temporary key even if I
>> don't supply and RSA key, to protect mlocked application data from being
>> present in the swap after restore?
>
> It can do that, but you need to provide a key during suspend and resume.
>
> Otherwise it doesn't use a random key, because it would have to store it in
> the clear in the image header.

So you don't feel like the "What is this 'Encrypt suspend image' for?"
Q&A in Documentation/swsusp.txt describes a real threat, do you?  If
an "application" has direct access to swap, then it's game over anyway.
-- 
Thanks,
Feri.
