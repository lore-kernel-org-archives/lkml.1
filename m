Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbXI0GOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbXI0GOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXI0GOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:14:33 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:58457 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXI0GOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=INe30fLVyHpTnATNE8q+foBxNNtKIT7fmjX9rdLMT2hbiE+QNIPpT38XoiVcKQOpLCpFBGX0eRjWZTO1/LFepQbUyx4k7jfZz6Os8AJNSjDqRASRJwQ6p1kGzBzpVO4g+4ypXBhji1qRX0bg5bbk3gmgyu7YmwSRXxqm1SnCKsA=
Message-ID: <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
Date: Thu, 27 Sep 2007 08:14:31 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46FB3843.2030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/07, Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
> > Torsten Kaiser wrote:
> >> Comparing the driver/ata directory from rc3-mm1 and rc4-mm1 the
> >> following change looked the most suspicions to me:
> >> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=blobdiff;f=drivers/ata/sata_sil24.c;h=3dcb223117be9739ee04d70b6bfc776a4b839a3f;hp=e0cd31aa8002350add53ba6ff07493e503275244;hb=020bc1bd8d369a77bd9379cd9763ac0057651753;hpb=8d4bdf8087e682df98bdb856f6ad451bf6d597e7
> >>
> >> That after rc4-mm1 the sata_sil24.c did not change anymore also
> >> matches the occurrence of the error.
> >>
> >> To confirm my theorie I exchanged the sata_sil24.c from rc8-mm1 with
> >> the version from rc3-mm1.
> >> I was able to boot the resulting kernel successfully 5 times, without
> >> the error happening again.
> >
> > Thanks a lot for chasing down the problem.  The changed code is address
> > initialization path and it's weird that it causes intermittent failures,
> > not a consistent one.
> >
> > Anyways, does the attached patch fix the problem?

I'm starting to *really* hate that bug.
My analysis was wrong, as I booted to modified 2.6.23-rc8-mm1 this
morning, that failed too. (Same error messages as -rc7-mm1 from the
first mail in this thread.)
So it's not that change that causes the breakage.

And I'm not really finding a good pattern to what boots fail and what work.
It seems to only fail, if I completely power off the system for
several hours. (Using the physical switch at the backside of the
powersupply, not the normal soft-off)

One of the five boots I tried yesterday, I also powered the system
completely off that way, but only leaving it off ~10..20 seconds
seemed not to trigger the bug.

But I still think that is not a hardware failure, as the -rc3-mm1
kernel never showed that error, even when I used it several times
after the first -rc4-mm1 failures.

> If not, can you add printk of iomap[SIL24_PORT_BAR], offset, initialized
> cmd_addr and scr_addr in the loop and see whether anything is different
> between when the driver works and fails.

Should I do this anyway?

I compared the dmesg form good and bad boots with -rc7-mm1 but could
not see any difference, so do you think that these additional
diagnostics could show a difference?
Or could you suggest any other debugging options I should try?

Torsten
