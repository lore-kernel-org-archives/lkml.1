Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbZADT1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbZADT1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbZADT0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:26:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:58217 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZADT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ggr3flOdsWcwQe7Mg96NJ1hycpLPAooB8DoI6fM+43sbR8RR0KFbEzTYQ6uopYbtG3
         TGX5GQPj+pvNl14bH9PQXhaaqdTsatdAMDwZuCuCzJYHcbByqKX0+Zfc3Rq3KB1w2AMY
         0M6YamnoHPgf9Gal5k71ZA1fzOSHjqK1v2/1o=
Message-ID: <49610BAA.4060308@googlemail.com>
Date: Sun, 04 Jan 2009 20:19:06 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081122)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:

Hi Dave ,

...


 
> Please pull the 'drm-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
> 
> Major highlights:
> Kernel Modesetting (KMS) core code (jbarnes you can go to drinking island 
> now)
> Intel i915 support for kernel modesetting


....



> commit 79e539453b34e35f39299a899d263b0a1f1670bd
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Fri Nov 7 14:24:08 2008 -0800
> 
>     DRM: i915: add mode setting support
>     
>     This commit adds i915 driver support for the DRM mode setting APIs.
>     Currently, VGA, LVDS, SDVO DVI & VGA, TV and DVO LVDS outputs are
>     supported.  HDMI, DisplayPort and additional SDVO output support will
>     follow.
>     
>     Support for the mode setting code is controlled by the new 'modeset'
>     module option.  A new config option, CONFIG_DRM_I915_KMS controls the
>     default behavior, and whether a PCI ID list is built into the module for
>     use by user level module utilities.
>     
>     Note that if mode setting is enabled, user level drivers that access
>     display registers directly or that don't use the kernel graphics memory
>     manager will likely corrupt kernel graphics memory, disrupt output
>     configuration (possibly leading to hangs and/or blank displays), and
>     prevent panic/oops messages from appearing.  So use caution when
>     enabling this code; be sure your user level code supports the new
>     interfaces.
>     
>     A new SysRq key, 'g', provides emergency support for switching back to
>     the kernel's framebuffer console; which is useful for testing.
>     
>     Co-authors: Dave Airlie <airlied@linux.ie>, Hong Liu <hong.liu@intel.com>
>     
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 


This commit added the following text to drivers/gpu/drm/Kconfig :

config DRM_I915_KMS
       bool "Enable modesetting on intel by default"
       depends on DRM_I915
       help
       Choose this option if you want kernel modesetting enabled by default,
       and you have a new enough userspace to support this. Running old
       userspaces with this enabled will cause pain.  Note that this causes
       the driver to bind to PCI devices, which precludes loading things
       like intelfb.


I don't think any 'normal' user has a clue what you guys meant by 
'new and old userspace' . Could someone clarify 'what versions of probably Xorg and libs are
needed to have that support and which are for sure broken or old' please ?

Also while testing this with xorg-server 1.4* I found out the 'pain' means an broken X and a broken box since 
it broke the kernel as well and the only way to get the box to live again was an hard reset. Please clarify the 'pain' part too.

Thanks for your time.

Best regards ,

Gabriel C


