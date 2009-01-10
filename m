Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZAJVmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZAJVmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZAJVlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:41:52 -0500
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:52732 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751005AbZAJVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:41:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=SAWYgc2DLlkQHkaJPPKtjoEvAfXBk4rJy4ne9RrXdoe8V5W1LaKmFXBTILXJSb9yRoJCG8nrSRgZB78x37jy/TkodfhgTLh3IokbZ90fwN8UiMFsAi3MymrWHFyiFxb6;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: [PATCH] i915: document DRM_I915_KMS option
Date: Sat, 10 Jan 2009 13:41:48 -0800
User-Agent: KMail/1.9.10
Cc: "Gabriel C" <nix.or.die@googlemail.com>, "Dave Airlie" <airlied@linux.ie>,
       torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, "Eric Anholt" <eric@anholt.net>
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie> <49610BAA.4060308@googlemail.com> <21d7e9970901091803o36f1f07dk6436d1fbe5b2d084@mail.gmail.com>
In-Reply-To: <21d7e9970901091803o36f1f07dk6436d1fbe5b2d084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101341.49159.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 9, 2009 6:03 pm Dave Airlie wrote:
> > Also while testing this with xorg-server 1.4* I found out the 'pain'
> > means an broken X and a broken box since it broke the kernel as well and
> > the only way to get the box to live again was an hard reset. Please
> > clarify the 'pain' part too.
>
> There is no new enough userspace yet, so I can't say what version will
> have it, maybe I should mark enabled by default as experimental or
> something.
>
> If pain doesn't equate to doing something that will hurt, then I'm not
> sure what will, it actually will work for some people, so I can't say
> it will always be broken.
>
> I'll see if Jesse can provide some nicer wordings...

How about something like this?  It's deliberately vague about the exact
userspace requirements (basically saying you have to do your homework first)
but is otherwise pretty clear I think.

This patch adds more documentation for the DRM_I915_KMS option, warning
users to be sure any existing software they want to use with the i915 driver
is capable of using the new interfaces provided.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 5130b72..57edf29 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -83,15 +83,21 @@ config DRM_I915
 endchoice
 
 config DRM_I915_KMS
-	bool "Enable modesetting on intel by default"
+	bool "Enable kernel mode setting by default"
 	depends on DRM_I915
 	help
-	Choose this option if you want kernel modesetting enabled by default,
-	and you have a new enough userspace to support this. Running old
-	userspaces with this enabled will cause pain.  Note that this causes
-	the driver to bind to PCI devices, which precludes loading things
-	like intelfb.
+	Choose this option if you want kernel based mode setting enabled by
+	default (normally you have to pass "modeset=1" as a module parameter
+	to enable this feature).  When kernel mode setting is enabled, the
+	driver will support the mode setting ioctls defined in drm_mode.h
+	(which should be used through libdrm's xf86drmMode.h interface).
 
+	Note that when this option is enabled, it will conflict with other
+	drivers of this hardware such as intelfb or a non-kernel mode setting
+	enabled xf86-video-intel (which include all versions prior to 2.6),
+	and so could lead to bad behavior like memory corruption, non-functional
+	video output, and machine hangs.  So if you plan to use this feature
+	be sure your installed userspace software is compatible.
 
 config DRM_MGA
 	tristate "Matrox g200/g400"

