Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZGNJzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZGNJzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZGNJzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:55:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35537 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbZGNJzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:55:20 -0400
Date: Tue, 14 Jul 2009 11:55:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
Message-ID: <20090714095511.GF2076@elf.ucw.cz>
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090710162105.GA1469@ucw.cz> <4A592C09.8060104@msgid.tls.msk.ru> <200907121707.11152.arnd@arndb.de> <4A5AD963.5070908@msgid.tls.msk.ru> <20090713202116.GB2569@elf.ucw.cz> <4A5C2C42.5030100@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5C2C42.5030100@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-14 10:57:06, Michael Tokarev wrote:
> Pavel Machek wrote:
> []
>>> In order to (try to) check if it works or not, another userspace
>>> component has to be fixed to support 32/64 bit mode.  It's uswsusp,
>>> which currently assumes swap space structures are all 32bits.  So
>>> it isn't possible to immediately check if it works or not -- just
>>> ioctl(s) aren't enough.  Complete fix (kernel+user space) requires
>>> both, fixing all remaining (yet unknown) issues in old and new
>>> code on the way.
>>
>> Well, there seems to be single structure in s2disk; that does not seem
>> that hard to fix.
>
> Which one do you mean?

struct swsusp_info should be the one...

> Also, do you want to make it 32/64 bit clean in userspace too, so that
> an image produced by 32-bit s2disk can be read by 64bit resume and
> vise versa?  Sure it's good thing to have, to avoid possible issues
> with 32bit initramfs on 64bit system for example...

It would be cool, but...

>>> For now, I think it's best to let Pavel or Rafael to decide what
>>> to do with all this.
>>
>> I don't currently have easy access to 64bit machine, so I guess it is
>> up to someone else.
> []
>
> Ok.  I applied Arnd's patch again (with two fixes -- adding
> #include <linux/compat.h> and s/compat_ulong/compat_ulong_t/ and
> tried suspend/resume cycle with unmodified uswsusp-0.8.  Suspend
> worked (seemengly - it reported about 4G pages written, on a
> machine with 4G memory) but resume failed after reading all the
> pages and submitting them to /dev/snapshot.
>
> I've no time right now to debug it further (and again, yet again:
> I don't know the code, neither kernel nor userspace part).
>
> So I'd merge this change for now and deal with possible bugs later.
>
> At least there's no failed ioctl()s on /dev/snapshot anymore,
> neither at suspend nor at resume time.

ACK.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
