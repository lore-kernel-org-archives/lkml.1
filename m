Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYLMOtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYLMOtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYLMOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:49:09 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:58584 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbYLMOtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QM4+WI8rnmbd6aJJYzUG5vOhCco6xnLr86OwBmd0YUpLC6xx0gEJq9R+kcndqQ/7xA
         BR8rBCtVQMvTniLCXUONdkkaZekAGbuRlEBunnhK2zfbObXcXJyvcolFmo0shb5KV7Gv
         +umMjEgJIxQadVtNjffrTpIz6IUPusrsy1DhI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Date: Sat, 13 Dec 2008 15:12:43 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Benny Amorsen <benny+usenet@amorsen.dk>
References: <200812012342.32575.bzolnier@gmail.com> <200812042118.17921.bzolnier@gmail.com> <200812072021.38931.bzolnier@gmail.com>
In-Reply-To: <200812072021.38931.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812131512.43868.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > > > On Wednesday 03 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > > > > On Tuesday 02 December 2008, Dave Airlie wrote:
> > > > > > On Tue, Dec 2, 2008 at 8:42 AM, Bartlomiej Zolnierkiewicz
> > > > > > <bzolnier@gmail.com> wrote:
> > > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > After Fedora 9 -> Fedora 10 upgrade vanilla kernels which previously
> > > > > > > worked fine (next-20081128 and next-20081121) started to hang randomly
> > > > > > > on my Pentium M / 855PM / RV350 laptop.  Since (surprisingly) stock
> > > > > > > Fedora kernel (2.6.27.5-117.fc10.i686) was not affected I got the idea
> > > > > > > that either userspace changes uncovered some kernel regression or some
> > > > > > > Fedora specific patch must be fixing the issue.  Unfortunately vanilla
> > > > > > > 2.6.27 also freezed so after the usual pain caused by hitting bunch of
> > > > > > > unrelated problems [1] it turned out that drm-modesetting-radeon.patch
> > > > > > > is the magic patch and CONFIG_DRM_RADEON_KMS is the magic change.  With
> > > > > > > the patch and enabling the option next-20081128 works stable again...
> > > > > > >
> > > > > > > Since the following error gets logged by kernel:
> > > > > > >
> > > > > > > [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
> > > > > > > [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.
> > > > > > >
> > > > > > > and it also seems that system is more responsive now (it was kind of
> > > > > > > sluggish previously) my draft theory is that F9 -> F10 triggered some
> > > > > > > AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
> > > > > > > but I'll leave figuring this up to the more knowledgeable people... ;)
> > > > > > 
> > > > > > Well KMS is a purely Fedora thing, and enabling it completely avoids
> > > > > > the old driver codepaths so
> > > > > > while it might fix it, its more by accident than design.
> > > > > > 
> > > > > > I'm trying to track down the rv3xx hangs with hpa at the moment as he
> > > > > > sees them also, something in
> > > > > >  the 2.6.26->2.6.27 timeframe. I'm hoping running the 2.6.26 drm on
> > > > > > the 2.6.27 will help narrow it down.
> > > > > > 
> > > > > > Bisecting 2.6.26->2.6.27 might also help.
> > > > > 
> > > > > It could be a different issue.  I tried 2.6.26, 2.6.25 and 2.6.24
> > > > > and they all hang (they all worked fine with Fedora 9)...
> > > > > 
> > > > > I will try some older kernels but I start thinking that the xorg's ati
> > > > > driver update is the main cause (xorg-x11-drv-ati-6.8.0-19.fc9.i386.rpm
> > > > > -> xorg-x11-drv-ati-6.9.0-54.fc10.i386.rpm).
> > > > 
> > > > I just went straight to trying downgrading the driver and the older driver
> > > > indeed works fine.  Then I tried to narrow down the problem and the lucky
> > > > winner this time is the cute (== undocumented and unsigned-off) patch
> > > > called radeon-6.9.0-remove-limit-heuristics.patch.  The newer driver with
> > > > only this patch reverted fixes hangs for vanilla kernels and drm errors
> > > > for Fedora kernel.  Also performance problems that I've noticed in the
> > > > meantime (slower playback of 720p videos, sluggish window scrolling in
> > > > kmail) are completely gone.  That being said I'm not entirely sure whether
> > > 
> > > I was too quick here -- performance problems are still present with
> > > _Fedora_ kernel.
> > > 
> > > Reassuming: what I currently need to do to get my gfx working properly
> > > with F10 is reverting radeon-6.9.0-remove-limit-heuristics.patch from
> > > xorg-x11-drv-ati and using vanilla kernel instead of Fedora's one.
> > 
> > Heh, and it just hang on me after sending the above mail (it took like
> > 1h or so for hang to occur) => the patch is just a very good trigger for
> > the "real" bug.  I'll now be running vanilla 6.9.0 to see how it goes...
> 
> It went well, "vanilla" in this case was xorg-x11-drv-ati-6.9.0-54.fc10
> content _without_ radeon-modeset.patch and _with_ patch containing commit
> da021c36bbdf3bca31ee50ebe01cdb9495c09b36 ("radeon_drm.h: remove kernel
> defines") from xf86-video-ati git tree (needed to make things compile).
> 
> I tried to bisect it futher using radeon-gem-cs branch (using edge commit
> deduced from radeon-modeset.patch) and managed to narrow it down further to
> somewhere between
> 
> commit 44fb767aa95e5f0725386106b89d0782fd53b768
> ("radeon: fixup modesetting code after rebasing to master")
> 
> and 
> 
> commit 12e71eaf7999520d23d50cfbcfc0299b2bdf7a9d
> ("port to using drm header files")
> 
> which left 66 commits which are completely unbisectable because of build
> problems and bugfixes.   I tried continuing with exporting commits from git
> to patches, importing patches to quilt and shuffling them around to make
> things bisectable again...  Unfortunately this turned out to be more time
> consuming than expected and I run out of time for this exercise...
> 
> Dave, do you have some ideas how can this be debugged further?
> (i.e. rebuilding radeon-gem-cs tree would greatly help)
> 
> Or maybe it is not worth it until trying some updates/fixes first?

FWIW all issues are still there with kernel-2.6.27.7-134.fc10.i686
and xorg-x11-drv-ati-6.9.0-61.fc10.i386.

Anyway I got a bit impatient by a lack of follow-up on this and resumed
the "rebuild radeon-gem-cs bisectability" operation (luckily the problem
was narrowed down to the second part of changes so I didn't have to do
100% of the work)...

Hangs seem to be caused by commit 5c5736604e6a1bc280821bd92f3714e0c9e7d7d3
("radeon: no need for this anymore"):

--- a/src/radeon_driver.c
+++ b/src/radeon_driver.c
@@ -1621,9 +1621,7 @@ static Bool RADEONPreInitVRAM(ScrnInfoPtr pScrn)
 
     pScrn->videoRam  &= ~1023;
 
-    /* half video RAM for TTM */
     info->FbMapSize  = pScrn->videoRam * 1024;
-    info->FbMapSize /= 2;
 
     /* if the card is PCI Express reserve the last 32k for the gart table */
 #ifdef XF86DRI

I'm now running Fedora's xorg-x11-drv-ati with only the above patch reverted
and so far it is rock stable.

Thanks,
Bart
