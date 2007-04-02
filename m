Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXDBBre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXDBBre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 21:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXDBBrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 21:47:33 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:33720 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXDBBrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 21:47:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 21:47:32 EDT
Date: Sun, 1 Apr 2007 18:40:03 -0700
From: Jouni Malinen <j@w1.fi>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeroen Vreeken <pe1rxq@amsat.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 15/16] use-regular-eth-suffix.diff
Message-ID: <20070402014003.GS16197@jm.kir.nu>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012010530.12316@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704012010530.12316@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 08:18:12PM +0200, Jan Engelhardt wrote:

> Some radio adapter drivers wrongly(?) name their devices "wlan%d"
> instead of "eth%d" (if you ask me, it should be %u - but not today).

> Technically, they operate like Ethernet, and in fact, running
> `/sbin/ip a` shows "link/ether" instead of "link/ieee80211".

The address may look like wired Ethernet (both are based on IEEE 802
standards), but IEEE 802.11 does not behave like IEEE 802.3. For
example, one cannot send frames with a foreign source address in client
mode when using IEEE 802.11 which is clearly different from wired
Ethernet. IEEE 802.11 interfaces (in client mode) cannot be bridged at
layer 2 in the same way as wired Ethernet interfaces could.

> This patch renames them back, but I would appreciate some comment,
> explanation or at least link why they actually have wlan%d there.

Renames _back_? No it doesn't. Host AP driver has never used eth%d as
the interface name template

> Index: linux-2.6.21-rc5/drivers/net/wireless/hostap/hostap_hw.c
> -static char dev_template[16] = "wlan%d";
> +static char dev_template[16] = "eth%d";

NAK. Host AP driver has been using wlan%d for close to seven years and I
see no reason to change it now. This will just cause problems for users.
If someone wants to rename the interface to something else, they can do
it with number of different ways from user space. The kernel default
should not be changed at this point.

-- 
Jouni Malinen                                            PGP id EFC895FA
