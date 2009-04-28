Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZD1Fh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZD1Fh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZD1FhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:37:14 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:61305 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZD1FhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <20090427234947.394f774f@schatten>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
	 <20090427234947.394f774f@schatten>
Date: Tue, 28 Apr 2009 06:37:10 +0100
X-Google-Sender-Auth: 9130c96ce607f779
Message-ID: <b2cdc9f30904272237h3a815282h7e6b932e1c252d17@mail.gmail.com>
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
From: Alex Bennee <kernel-hacker@bennee.com>
To: Florian Mickler <florian@mickler.org>
Cc: xorg@freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/27 Florian Mickler <florian@mickler.org>:
> On Sun, 19 Apr 2009 07:27:35 +0100
> Alex Bennee <kernel-hacker@bennee.com> wrote:
>
>> Heading the warnings in the menuconfig I did try and ensure I have all
>> the up to date parts of user-space. With KMS enabled GDM starts up but
>> then corrupts the display with vertical lines. Disabling the kernel
>> config and everything starts up fine, UXA acceleration seems OK and
>> the speed of compiz is finally back up to ~60fps thanks to the A17
>> fix.
>>
>> Am I missing another bit of user space for KMS to work properly?

Apparently I was missing a key bit and had to enable fbdev from the
command line:

kernel /kernel-2.6-drm root=/dev/sda2
video=intelfb:mode=1440x900-32@75,accel,hwcursor

However I still saw the same corruption kick in when GDM started. I
couldn't switch mode either which kinda defeated the point.

><snip>
>
> hm, are you using the xf86-video-intel git-branch "2.7"? if i use that,
> i need a kernel fix queued in eanholts for-linus git-tree or else i
> also get unusable X.

No, I'm using the actual released 2.7.0 driver (as built via a simple
Gentoo ebuild)

> i assumed that this was because of some not-yet-released fixes
> on the 2.7-branch which will get released as soon as erics queue is
> merged? but i didn't double check ...  maybe the released version is
> also broken in this regard for me....

I tried again with the latest drm-intel kernel git tree @

commit 44ab43155e8071fbf037513e57de9a79044edf56
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Apr 1 19:53:33 2009 +0100

    drm/i915: Enable ASLE if present

    The changes to opregion initialisation order meant that the ASLE setup
    code might not be run at the correct time. Ensure that the interrupts are
    set up.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>


Still broken :-(


-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
