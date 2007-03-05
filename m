Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXCEXkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXCEXkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXCEXkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:40:53 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50989 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbXCEXkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:40:51 -0500
Date: Tue, 6 Mar 2007 00:40:52 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070305234052.GR3441@stusta.de>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070305185813.GA31465@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 10:58:13AM -0800, Greg KH wrote:
> 
> Ok, how about the following patch.  Is it acceptable to everyone?
> 
> thanks,
> 
> greg k-h
> 
> ---
>  init/Kconfig |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> --- gregkh-2.6.orig/init/Kconfig
> +++ gregkh-2.6/init/Kconfig
> @@ -290,8 +290,17 @@ config SYSFS_DEPRECATED
>  	  that belong to a class, back into the /sys/class heirachy, in
>  	  order to support older versions of udev.
>  
> -	  If you are using a distro that was released in 2006 or later,
> -	  it should be safe to say N here.
> +	  If you are using an OpenSuSE, Gentoo, Ubuntu, or Fedora
> +	  release from 2007 or later, it should be safe to say N here.
> +
> +	  If you are using Debian or other distros that are slow to
> +	  update HAL, please say Y here.
>...

The sane solution seems to be to enable SYSFS_DEPRECATED unconditionally 
for all users, and schedule it's removal for mid-2008 (or later).

12 months after the first _release_ of a HAL that can live without seems 
to be the first time when we can consider getting rid of it, since all 
distributions with at least one release a year should ship it by then.

Currently, SYSFS_DEPRECATED is only a trap for users.

Suggested patch below.

cu
Adrian


<--  snip  -->


unconditionally enable SYSFS_DEPRECATED

This patch unconditionally enables SYSFS_DEPRECATED and schedules it's
removal for July 2008.

Currently, SYSFS_DEPRECATED is only a trap for users accidentally
disabling it.

In July 2008, all distributions with at least one release a year should
be able to run without SYSFS_DEPRECATED.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c3b1430..b0bce93 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -316,3 +316,13 @@ Why:	The option/code is
 Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
+
+What:	deprecated sysfs files (CONFIG_SYSFS_DEPRECATED)
+When:	July 2008
+Why:	None of these features or values should be used any longer,
+	as they export driver core implementation details to userspace
+	or export properties which can't be kept stable across kernel
+	releases.
+Who:	Greg KH <greg@kroah.com>
+
+---------------------------
diff --git a/init/Kconfig b/init/Kconfig
index f977086..f652b6f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -274,24 +274,9 @@ config CPUSETS
 	  Say N if unsure.
 
 config SYSFS_DEPRECATED
-	bool "Create deprecated sysfs files"
+	bool
 	default y
 	help
-	  This option creates deprecated symlinks such as the
-	  "device"-link, the <subsystem>:<name>-link, and the
-	  "bus"-link. It may also add deprecated key in the
-	  uevent environment.
-	  None of these features or values should be used today, as
-	  they export driver core implementation details to userspace
-	  or export properties which can't be kept stable across kernel
-	  releases.
-
-	  If enabled, this option will also move any device structures
-	  that belong to a class, back into the /sys/class heirachy, in
-	  order to support older versions of udev.
-
-	  If you are using a distro that was released in 2006 or later,
-	  it should be safe to say N here.
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
