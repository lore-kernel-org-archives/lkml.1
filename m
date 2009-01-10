Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZAJCDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZAJCDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 21:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZAJCDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 21:03:12 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:7349 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZAJCDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 21:03:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TNF4IUipmmaZl4QkQQ+5n/zS0QAwqNRwzdXqyi5f8F+alQuaqAKooscef4RrMhxvmV
         v/H//FR32Zq9DdEZ8pxlZOEOv5ZBCJ/ycmSm7sMkg99h7Ifya+rVouzwON1a51nTgc8o
         IDZ1bmFIV814wPoeoRSSf0J62FAep7DShvYiQ=
Message-ID: <21d7e9970901091803o36f1f07dk6436d1fbe5b2d084@mail.gmail.com>
Date: Sat, 10 Jan 2009 12:03:08 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [git pull] drm
Cc: "Dave Airlie" <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>
In-Reply-To: <49610BAA.4060308@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <49610BAA.4060308@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 5:19 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Dave Airlie wrote:
>
> Hi Dave ,
>
> ...
>
>
>
>> Please pull the 'drm-next' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
>>
>> Major highlights:
>> Kernel Modesetting (KMS) core code (jbarnes you can go to drinking island
>> now)
>> Intel i915 support for kernel modesetting
>
>
> ....
>
>
>
>> commit 79e539453b34e35f39299a899d263b0a1f1670bd
>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Date:   Fri Nov 7 14:24:08 2008 -0800
>>
>>     DRM: i915: add mode setting support
>>
>>     This commit adds i915 driver support for the DRM mode setting APIs.
>>     Currently, VGA, LVDS, SDVO DVI & VGA, TV and DVO LVDS outputs are
>>     supported.  HDMI, DisplayPort and additional SDVO output support will
>>     follow.
>>
>>     Support for the mode setting code is controlled by the new 'modeset'
>>     module option.  A new config option, CONFIG_DRM_I915_KMS controls the
>>     default behavior, and whether a PCI ID list is built into the module for
>>     use by user level module utilities.
>>
>>     Note that if mode setting is enabled, user level drivers that access
>>     display registers directly or that don't use the kernel graphics memory
>>     manager will likely corrupt kernel graphics memory, disrupt output
>>     configuration (possibly leading to hangs and/or blank displays), and
>>     prevent panic/oops messages from appearing.  So use caution when
>>     enabling this code; be sure your user level code supports the new
>>     interfaces.
>>
>>     A new SysRq key, 'g', provides emergency support for switching back to
>>     the kernel's framebuffer console; which is useful for testing.
>>
>>     Co-authors: Dave Airlie <airlied@linux.ie>, Hong Liu <hong.liu@intel.com>
>>
>>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>     Signed-off-by: Eric Anholt <eric@anholt.net>
>>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>>
>
>
> This commit added the following text to drivers/gpu/drm/Kconfig :
>
> config DRM_I915_KMS
>       bool "Enable modesetting on intel by default"
>       depends on DRM_I915
>       help
>       Choose this option if you want kernel modesetting enabled by default,
>       and you have a new enough userspace to support this. Running old
>       userspaces with this enabled will cause pain.  Note that this causes
>       the driver to bind to PCI devices, which precludes loading things
>       like intelfb.
>
>
> I don't think any 'normal' user has a clue what you guys meant by
> 'new and old userspace' . Could someone clarify 'what versions of probably Xorg and libs are
> needed to have that support and which are for sure broken or old' please ?
>
> Also while testing this with xorg-server 1.4* I found out the 'pain' means an broken X and a broken box since
> it broke the kernel as well and the only way to get the box to live again was an hard reset. Please clarify the 'pain' part too.

There is no new enough userspace yet, so I can't say what version will
have it, maybe I should mark enabled by default as experimental or
something.

If pain doesn't equate to doing something that will hurt, then I'm not
sure what will, it actually will work for some people, so I can't say
it will always be broken.

I'll see if Jesse can provide some nicer wordings...

Dave.
