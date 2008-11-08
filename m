Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYKHP7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYKHP7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYKHP7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:59:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYKHP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:59:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4915B769.6090403@s5r6.in-berlin.de>
Date: Sat, 08 Nov 2008 16:59:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] Staging: only build the tree if we really want to
References: <20081108054511.GA28846@kroah.com> <1226123143-28859-1-git-send-email-greg@kroah.com>
In-Reply-To: <1226123143-28859-1-git-send-email-greg@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -21,7 +21,23 @@ menuconfig STAGING
>  
>  	  If in doubt, say N here.
>  
> -if STAGING
> +
> +config STAGING_EXCLUDE_BUILD
> +	bool "Exclude Staging drivers from being built"
> +	default y
> +	---help---
...
> +if !STAGING_EXCLUDE_BUILD
>  
>  source "drivers/staging/et131x/Kconfig"
>  
> @@ -45,4 +61,4 @@ source "drivers/staging/at76_usb/Kconfig"
>  
>  source "drivers/staging/poch/Kconfig"
>  
> -endif # STAGING
> +endif # !STAGING_EXCLUDE_BUILD

Which purpose is the STAGING kconfig variable serving after this?  It
controls the visibility of the menu, but switching it off won't switch
off the staging drivers if they were previously enabled, would it?
-- 
Stefan Richter
-=====-==--- =-== -=---
http://arcgraph.de/sr/
