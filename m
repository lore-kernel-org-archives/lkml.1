Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYLBFTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYLBFTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 00:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYLBFS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 00:18:57 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:43305 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYLBFS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 00:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oeQt0ToInO6FkbKCDX5XKurr/f5ykaBS52DVxgY8o2L+vFy4eelhzGAnuyLlPCvbPc
         BgjyVZVKJYKVcnu3BPrggtHC8UePxmYDP5oWU3bAy2ySE6Cax7podR2HGjLxjjPbcRnV
         6bqjrN8THS539HGl6Mw7rJOsuOTKXJl/M0bfs=
Message-ID: <21d7e9970812012118r7196a507me0a25fe967f60ff4@mail.gmail.com>
Date: Tue, 2 Dec 2008 15:18:55 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Cc: "Dave Airlie" <airlied@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200812012342.32575.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812012342.32575.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 8:42 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> Hi,
>
> After Fedora 9 -> Fedora 10 upgrade vanilla kernels which previously
> worked fine (next-20081128 and next-20081121) started to hang randomly
> on my Pentium M / 855PM / RV350 laptop.  Since (surprisingly) stock
> Fedora kernel (2.6.27.5-117.fc10.i686) was not affected I got the idea
> that either userspace changes uncovered some kernel regression or some
> Fedora specific patch must be fixing the issue.  Unfortunately vanilla
> 2.6.27 also freezed so after the usual pain caused by hitting bunch of
> unrelated problems [1] it turned out that drm-modesetting-radeon.patch
> is the magic patch and CONFIG_DRM_RADEON_KMS is the magic change.  With
> the patch and enabling the option next-20081128 works stable again...
>
> Since the following error gets logged by kernel:
>
> [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
> [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.
>
> and it also seems that system is more responsive now (it was kind of
> sluggish previously) my draft theory is that F9 -> F10 triggered some
> AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
> but I'll leave figuring this up to the more knowledgeable people... ;)

Well KMS is a purely Fedora thing, and enabling it completely avoids
the old driver codepaths so
while it might fix it, its more by accident than design.

I'm trying to track down the rv3xx hangs with hpa at the moment as he
sees them also, something in
 the 2.6.26->2.6.27 timeframe. I'm hoping running the 2.6.26 drm on
the 2.6.27 will help narrow it down.

Bisecting 2.6.26->2.6.27 might also help.

Dave.
