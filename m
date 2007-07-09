Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbXGIXrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbXGIXrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbXGIXrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:47:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46121 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbXGIXrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:47:25 -0400
Date: Tue, 10 Jul 2007 01:47:14 +0200 (MEST)
Message-Id: <200707092347.l69NlElB023451@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linuxppc-dev@ozlabs.org
Subject: [2.6.22] powerpc: section mismatch for macmodes.c:mac_find_mode()
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A vanilla 2.6.22 built for ppc32 and configured with CONFIG_FB_MACMODES=y, CONFIG_HOTPLUG=n,
and CONFIG_MODULES=y, triggers the following warning from modpost:

WARNING: drivers/built-in.o(__ksymtab+0x3b0): Section mismatch: reference to .init.text:mac_find_mode (between '__ksymtab_mac_find_mode' and '__ksymtab_mac_map_monitor_sense')

There's an EXPORT_SYMBOL(mac_find_mode), but mac_find_mode() is __devinit
and thus __init in this kernel.

/Mikael
