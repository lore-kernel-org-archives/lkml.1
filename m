Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXKOTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXKOTdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbXKOTdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:33:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbXKOTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:33:03 -0500
Date: Thu, 15 Nov 2007 11:25:37 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115192537.GB30186@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 05:59:06PM -0800, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> - In response to various people needing to get at the mm tree in a timely
>   fashion I have created "MM of the minute", at
> 
> 	http://userweb.kernel.org/~akpm/mmotm/
> 
>   I'll upload the patch queue there multiple times per day.  I will attempt
>   to ensure that the patches in there actually apply, but they sure as heck
>   won't all compile and run.
> 
> - 2.6.24-rc2-mm1 may oops during shutdown and reboot.  This is due to
>   gregkh-driver-kset-convert-sys-devices-system-to-use-kset_create.patch. 
>   It's a known problem, but if you have additional insights into what causes
>   it, feel free to let Greg know.

Here's a patch, from Kay, to fix this issue.

If anyone still has problems after applying this patch, with shutdown
things, please let me know.

I'll roll it into my larger patchset so that Andrew can get it
automatically for the next release.

thanks,

greg k-h
----------------

From: Kay Sievers
Subject: fix oops in device_shutdown()


---
 drivers/base/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -451,7 +451,7 @@ int sysdev_resume(void)
 int __init system_bus_init(void)
 {
 	system_kset = kset_create_and_register("system", NULL,
-					       NULL, devices_kset);
+					       &devices_kset->kobj, NULL);
 	if (!system_kset)
 		return -ENOMEM;
 	return 0;
