Return-Path: <linux-kernel-owner+w=401wt.eu-S1030953AbXDWB76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030953AbXDWB76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 21:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030954AbXDWB76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 21:59:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:9093 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030953AbXDWB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 21:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZEjcsViPwfS5L/tpzmKCvFRhvrcT2BVmVAq3wpjaXxoQd8T3Zw1i/4jAN/muWIfPU7cM4Vv8wixfxiko1C334sq/KdGRGkNbNW0kAsho/nvW+aSk6hpSIogG6uq+50ZBR2knGEDWnR6qNb/Rtc9uO3NZhv+ascG096rTssCnxko=
Message-ID: <6700d24e0704221859h63c2ed1cnff21f15bd33dca8d@mail.gmail.com>
Date: Sun, 22 Apr 2007 18:59:55 -0700
From: hechacker1 <hechacker1@gmail.com>
Subject: Fwd: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.46
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6700d24e0704221809v572cff44n52b30b3930fd79cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704230103.15265.kernel@kolivas.org>
	 <6700d24e0704221809v572cff44n52b30b3930fd79cf@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: hechacker1 <hechacker1@gmail.com>
Date: Apr 22, 2007 6:09 PM
Subject: Re: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.46
To: Con Kolivas <kernel@kolivas.org>

First of all, thank you for your continued development of SD. I've
been using RSDL v.30 since it came out with skunk-sources (a gentoo
patchset). It has ran stable since that time.

I went ahead and taught myself how to patch a kernel together so I
could try  SD-0.46.

hechacker1@700m ~ $ uname -a
Linux 700m 2.6.21-rc7-sd046-rsdl #2 PREEMPT Sun Apr 22 15:13:36 PDT
2007 i686 Intel(R) Pentium(R) M processor 1.70GHz GenuineIntel
GNU/Linux

My findings:
SD 0.46 is much more responsive than RSDL  0.30. I have portage niced
to 19, make -j2, and it doesn't interfere with Xorg/Beryl at all.
Animations are silky smooth in beryl compared to the standard 2.6.21
scheduler which lags/becomes jerky when there is any kind of load (and
nicing it didn't help). This is especially important since I use
resier4 with cryptcompress (lzo) and it does peg out my CPU at 100%
during portage database rebuilds and searches. Not to mention all the
untaring/unzipping that portage does to build from source (and i have
everything built in tmpfs, so there isn't an i/o limitation).

I have rr_interval at 6 ms.

Xorg is "slightly" more responsive (doesn't lag) under load with nice
-10, although I also have beryl and emerald to worry about too since
they draw the windows and consume cpu. Xorg with nice 0 is still
responsive under all loads, so at least the tweak isn't required.

So far this is my new favorite scheduler. I'm compiling openoffice in
the background right now and I can't even notice it.

I will spend some time with this scheduler to get a feel for its
performance and later try CFS to get a comparison.



On 4/22/07, Con Kolivas <kernel@kolivas.org > wrote:
>  Yet another significant bugfix for SMP balancing was just posted for the
> staircase deadline cpu scheduler which improves behaviour dramatically on any
> SMP machine.
>
> Thanks to Willy Tarreau for noticing more bugs.
>
> As requested was a version in the Makefile so this version of the patch
> adds -sd046 to the kernel version.
>
>  http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.46.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.46.patch
>
> Renicing X to -10, while not essential, may be desirable on the desktop.
> Unlike the CFS scheduler which renices X without your intervention to
> nice -19, the SD patches do not alter nice level on their own.
>
> See the patch just posted called 'sched: implement staircase deadline
>  scheduler load  weight fix' for details of the fixes.
>
> Thanks to all testing and giving feedback.
>
> Well I'm exhausted...
>
> --
> -ck
> _______________________________________________
>   http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
>  http://vds.kolivas.org/mailman/listinfo/ck
>
