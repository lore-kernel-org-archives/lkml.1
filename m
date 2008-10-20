Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYJTB7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYJTB7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYJTB6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:58:55 -0400
Received: from mail.anarazel.de ([217.115.131.40]:60671 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbYJTB6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:58:55 -0400
From: Andres Freund <andres@anarazel.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 03:58:51 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200300.01411.andres@anarazel.de> <1224466521.5303.41.camel@koto.keithp.com>
In-Reply-To: <1224466521.5303.41.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200358.52147.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 20 October 2008 03:35:21 Keith Packard wrote:
> On Mon, 2008-10-20 at 03:00 +0200, Andres Freund wrote:
> > Hm. But still, there is at least one distribution (ubuntu intrepid) which
> > will propably will ship 2.4.1 in its stable version soon (it seems
> > unlikely that they will update to an unstable version just before an
> > release).
> We can backport the fix (it's tiny) to the 2.4 2D driver.
Its basically only this, right?

diff --git a/src/i830_driver.c b/src/i830_driver.c
index c1d61f4..eaf5d27 100644
--- a/src/i830_driver.c
+++ b/src/i830_driver.c
@@ -502,8 +502,8 @@ I830DetectMemory(ScrnInfoPtr pScrn)
    range = gtt_size + 4;
 
    /* new 4 series hardware has seperate GTT stolen with GFX stolen */
-   if (IS_G4X(pI830))
-       range = 0;
+   if (IS_G4X(pI830) || IS_GM45(pI830))
+       range = 4;
 
    if (IS_I85X(pI830) || IS_I865G(pI830) || IS_I9XX(pI830)) {
       switch (gmch_ctrl & I855_GMCH_GMS_MASK) {

Barring that I have absolutely idea about the code and all related stuff, do I 
see it correct, that this also will result in problems if the kernel doesn't 
have the related fix?

> > Which means, that this driver will get quite some spread...
> > Is it accepted that the kernel abi breaks that radically/fast?
> We tested a pile of hardware and didn't find any GM45s that worked, so
> we assumed they were all broken and that fixing the bug wouldn't cause
> any working configurations to stop working.
Seems sensible from your side.

> We can hack up the kernel so the old X server just gets a WARN_ON
> instead of breaking. This is a bit worrying though; the "fix" would let
> user space continue to mis-program the hardware.
If its really only a that small portion of hardware... At least the T500/T400 
series, containing the same hw as mine, from Lenovo propably is not yet really 
wide spread (Laptop is 4weeks old or so and wasn't available before).

> My concern here is that a common failure mode with this bug was to lock
> up the graphics hardware and require a reboot. Having the X server fail
> to start and leave the system in text mode where new packages can be
> installed seems like a better mode than making the system hang during
> boot.
Right.

Andres
