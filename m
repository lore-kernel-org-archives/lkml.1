Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYLDGS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYLDGS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYLDGSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:18:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46984
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYLDGSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:18:15 -0500
Date: Wed, 03 Dec 2008 22:18:15 -0800 (PST)
Message-Id: <20081203.221815.80265808.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: shemminger@vyatta.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: m68k 8390 breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812032135220.10635@anakin>
References: <Pine.LNX.4.64.0812032042480.10635@anakin>
	<20081203115622.50256091@extreme>
	<Pine.LNX.4.64.0812032135220.10635@anakin>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 3 Dec 2008 21:38:41 +0100 (CET)

> Oops, the log above is from allmodconfig and indeed doesn't show it.
> 
> mac_defconfig (which has CONFIG_MAC8390=y) shows more info:
> 
> | drivers/net/lib8390.c:303: warning: '__ei_start_xmit' defined but not used
> | drivers/net/lib8390.c:881: warning: '__ei_get_stats' defined but not used
> | drivers/net/lib8390.c:990: warning: '__ei_set_multicast_list' defined but not
> | ...
> | drivers/built-in.o: In function `ethdev_setup':
> | mac8390.c:(.text+0x29684): undefined reference to `ei_start_xmit'
> | mac8390.c:(.text+0x2968c): undefined reference to `ei_get_stats'
> | mac8390.c:(.text+0x29694): undefined reference to `ei_set_multicast_list'
> 
> defconfig log at http://kisskb.ellerman.id.au/kisskb/buildresult/58646/

This mac8390 driver uses the lib8390.c/8390.[ch] mechanism a little
bit oddly, but of course we should not have broken it :-)

Stephen please take a look, thanks!
