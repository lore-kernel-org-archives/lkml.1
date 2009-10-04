Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZJDNol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZJDNol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 09:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZJDNok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 09:44:40 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45357 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbZJDNoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 09:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=TZ5j5Gm0hxK2Ru1jGLlE4KIHffgyArtb87+uYmfUtmKZ3JdbZo7qQgHS+eXPgb5Oah
         OZ3ZiVbLAnHKgCvheeTt5SjwvOMMxM9KN3FyLNAu9Dk6abscg7LriCtam3MtZLgVroTs
         PMNQjE7JxcdgsGr2UCXuXeB275VdfQ0otRJk0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400 laptops
Date: Sun, 4 Oct 2009 15:43:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc2; KDE/4.3.2; x86_64; ; )
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
In-Reply-To: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910041543.57479.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 of October 2009, Theodore Ts'o wrote:
> Hi,
> 
> In recent kernels, my X display (running with a KMS-enabled X server)
> has been very jittery and with lots of glitching and tearing --- sorry
> if this isn't the correct technical term, not sure what it is --- on my
> T400 Lenovo laptop.   It seems related to what is on the desktop, and
> moving the mouse does seem to affect the rate and percentage of the
> screen which jitters --- which is enough to be very distracting,
> although I can still read the contents of the windows where the screen
> is tearing/glitching/flashing.
> 
> I bisected it down to this commit:
> 
> 74dff282237ea8c0a5df1afd8526eac4b6cee063 is the first bad commit
> commit 74dff282237ea8c0a5df1afd8526eac4b6cee063
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Sep 14 15:39:40 2009 -0700
> 
>     drm/i915: framebuffer compression for GM45+

Disabling compression works fine (as temporary workaround until the issue is 
solved).

diff --git a/drivers/gpu/drm/i915/intel_display.c 
b/drivers/gpu/drm/i915/intel_display.c
index 7a5fb79..075092b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4165,7 +4165,7 @@ static void intel_init_display(struct drm_device *dev)
 
 	/* Only mobile has FBC, leave pointers NULL for other chips */
 	if (IS_MOBILE(dev)) {
-		if (IS_GM45(dev)) {
+		if (0 && IS_GM45(dev)) {
 			dev_priv->display.fbc_enabled = g4x_fbc_enabled;
 			dev_priv->display.enable_fbc = g4x_enable_fbc;
 			dev_priv->display.disable_fbc = g4x_disable_fbc;


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
