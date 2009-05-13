Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbZEMTI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbZEMTI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbZEMTIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:08:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZEMTIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:08:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Olga Kornievskaia <aglo@citi.umich.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "J. Bruce Fields" <bfields@fieldses.org>, Jim Rees <rees@umich.edu>,
       linux-nfs@vger.kernel.org
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone  over NFS
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
	<20090508120119.8c93cfd7.akpm@linux-foundation.org>
	<20090511081415.GL4694@kernel.dk>
	<x49skjb21b7.fsf@segfault.boston.devel.redhat.com>
	<20090511165826.GG4694@kernel.dk>
	<x494ovp4r51.fsf@segfault.boston.devel.redhat.com>
	<20090512204433.7eb69075.akpm@linux-foundation.org>
	<x49y6t1rqw0.fsf@segfault.boston.devel.redhat.com>
	<b4ff356f0905130920v184ab529mb52a4346d4c77c14@mail.gmail.com>
	<20090513093229.097b47d2.akpm@linux-foundation.org>
	<b4ff356f0905131116o48181ccu4786578cc72c8ceb@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 13 May 2009 15:06:55 -0400
In-Reply-To: <b4ff356f0905131116o48181ccu4786578cc72c8ceb@mail.gmail.com>
	(Olga Kornievskaia's message of "Wed, 13 May 2009 14:16:42 -0400")
Message-ID: <x49vdo4u8j4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olga Kornievskaia <aglo@citi.umich.edu> writes:

> On Wed, May 13, 2009 at 12:32 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Wed, 13 May 2009 12:20:57 -0400 Olga Kornievskaia <aglo@citi.umich.edu> wrote:
>>
>>> I believe what you are seeing is how well TCP autotuning performs.
>>> What old NFS code was doing is disabling autotuning and instead using
>>> #nfsd thread to scale TCP recv window. You are providing an example of
>>> where setting TCP buffer sizes outperforms TCP autotuning. While this
>>> is a valid example, there is also an alternative example of where old
>>> NFS design hurts performance.
>>
>> <scratches head>
>>
>> Jeff's computer got slower.  Can we fix that?
>
> We realize that decrease performance is a problem and understand that
> reverting the patch might be the appropriate course of action!

I wasn't suggesting that we just revert the patch.  I was just looking
for some guidance on diagnosing and hopefully fixing the regression.

> But we are curious why this is happening. Jeff if it's not too much trouble
> could you generate tcpdumps for both cases. We are curious what are
> the max window sizes in both cases? Also could you give us your tcp and
> network sysctl values for the testing environment (both client and server
> values) that you can get with "sysctl -a | grep tcp" and also
> " | grep net.core".

http://people.redhat.com/jmoyer/iozone-regression.tar

I'm happy to continue to help track this down.  If you want to reproduce
this in your own environment, though, you can probably do it with a
ramdisk served up via nfs with the nfs client and server on the same
gig-e network.

> Poor performance using TCP autotuning can be demonstrated outside
> of NFS but using Iperf. It can be shown that iperf will work better if "-w"
> flag is used. When this flag is set, Iperf calls setsockopt() call which in
> the kernel turns off autotuning.
>
> As for fixing this it would be great if we could get some help from the
> TCP kernel folks?

Then we'll need to add netdev to the CC, but probably from a message
that has more background on the problem (we've even trimmed the
offending commit and performance numbers from the email at this point).

Cheers,
Jeff
