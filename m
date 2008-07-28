Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbYG1Vlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbYG1Vlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYG1VlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:41:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47877 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbYG1VlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:41:23 -0400
Date: Tue, 29 Jul 2008 00:40:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh se7750_defconfig compile error
Message-ID: <20080728214039.GE7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ffb91ad2751723bcc9925cd38e37013e2169e256
(sh: Solution Enginge 7710/7712 SH-Ether support)
causes the following compile error with se7750_defconfig:

<--  snip  -->

...
  CC      arch/sh/boards/se/770x/setup.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/boards/se/770x/setup.c:134: error: 'PHY_ID' undeclared here (not in a function)
make[2]: *** [arch/sh/boards/se/770x/setup.o] Error 1

<--  snip  -->

The patch did:
#if defined(CONFIG_CPU_SUBTYPE_SH7710)
# define PHY_ID 0x00
#elif defined(CONFIG_CPU_SUBTYPE_SH7712)
# define PHY_ID 0x01
#endif

But in this case we have CONFIG_CPU_SUBTYPE_SH7750.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

