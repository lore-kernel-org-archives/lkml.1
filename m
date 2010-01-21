Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694Ab0AUMe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0AUMe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671Ab0AUMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:34:27 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64889 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0AUMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:34:26 -0500
Date: Thu, 21 Jan 2010 14:28:39 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Sergey Lapin <slapinid@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
Message-ID: <20100121122839.GB26015@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jan 2010 12:29:22.0750 (UTC) FILETIME=[5C942DE0:01CA9A95]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:26:49PM +0100, ext Sergey Lapin wrote:
>Hi! I have crashes in MUSB code when working with USB gadget drivers.
>Kernel version: linux-omap master d8ebff302ff819587377b123e900e501e4135d86
>To reproduce: (USB device cable should be attached).
>
>dd if=/dev/zero of=/tmp/disk bs=1k count=1024
>mkdosfs -F 32 /tmp/disk
>insmod g_mass_storage  file=/tmp/disk stall=0
>
>Wait till disk is mounted on host, then
>
>rmmod g_mass_storage
>insmod g_mass_storage  file=/tmp/disk stall=0
>
>And here we get Oops in include/linux/list.h line 93,

I guess it's the list corruption bug, right ?

I've seen that, but couldn't get it to reproduce. Now that you said, 
I'll try to find a fix for it.

-- 
balbi
