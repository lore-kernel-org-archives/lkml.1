Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXL3USs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXL3USs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbXL3USj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:18:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50927 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXL3USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:18:39 -0500
Date: Sun, 30 Dec 2007 21:18:38 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: linux-kernel@vger.kernel.org
Subject: Re: allmodconfig:  udev won`t start due to CONFIG_UNIX=m
In-Reply-To: <77171111@web.de>
Message-ID: <Pine.LNX.4.64.0712302112510.2093@fbirervta.pbzchgretzou.qr>
References: <77171111@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 30 2007 21:11, devzero@web.de wrote:
>
>i build a kernel with allmodconfig and didn`t get my system to boot with that.
>
>after some investigation i found that it was due to udev:
>
>udevd[1226]: init_udev_socket: error getting socket: Address family not supported by protocol 
>
>this was missing support UNIX DOMAIN SOCKETS at boot time.
>easy - so i added unix.ko to my initrd.
>
>but that didn`t make a difference. Still same error with udev.
>
>seems, there are others who stepped into this trap and someone telling, unix domain sockets cannot be modular
>https://forums.gentoo.org/viewtopic-t-476363-highlight-.html
>https://forums.gentoo.org/viewtopic-t-463793-highlight-.html
>
>
>since we have 1206 options set to "Y" anyway, would it make sense to remove module support for Unix Domain Sockets ?
>opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=y" |wc -l
>1206
>opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=m" |wc -l
>2098
>
>i also came across this one:
>
>http://readlist.com/lists/vger.kernel.org/linux-kernel/41/205717.html
>

I'd rather much do in the Kconfig:

config UNIX
	tristate "UNIX domain sockets" if I_KNOW_WHAT_I_AM_DOING # currently called CONFIG_EMBEDDED
	bool "UNIX domain sockets"
