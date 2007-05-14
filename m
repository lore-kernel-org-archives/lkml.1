Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbXENXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbXENXAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbXENXA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:00:28 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:52502 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbXENXA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:00:26 -0400
Message-ID: <4648E9CB.2000509@gentoo.org>
Date: Mon, 14 May 2007 18:59:23 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kevin Lloyd <klloyd@sierrawireless.com>
CC: gregkh@suse.de, mdharm-usb@one-eyed-alien.net,
       linux-usb-users@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-storage: Add support for unusual device by Sierra
 Wireless
References: <4648D851.2030500@sierrawireless.com>
In-Reply-To: <4648D851.2030500@sierrawireless.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Lloyd wrote:
> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> This patch is targeted for the 2.6.21.1 kernel source. It adds support
> for Sierra Wireless devices with auto-install support to the 
> unusual_devices list of the usb-mass storage driver. This requires 
> changes to Kconfig, Makefile, usb.c, unusual_devs.h, and the addition of 
> sierra_ms.h & sierra_ms.c.

We have to do a similar thing for some zd1211rw USB-wireless devices, 
which appear as a virtual CDROM drive on plugin. To convert them to a 
proper wireless device, the cdrom has to be ejected, then the device 
disconnects and reconnects with different ID's (and the wireless endpoints).

Originally I wrote a usb-storage subdriver to handle the auto-eject, but 
this was rejected. It was decided to make usb-storage simply ignore the 
devices, and have the zd1211rw driver do the eject operation. The same 
may also apply in your case. See the US_FL_IGNORE_DEVICE flag, and the 
DEVICE_INSTALLER handling in drivers/net/wireless/zd1211rw/zd_usb.c

Daniel

