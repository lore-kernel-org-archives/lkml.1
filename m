Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXFOUkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXFOUkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbXFOUkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:40:35 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36280 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759061AbXFOUke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:40:34 -0400
Date: Fri, 15 Jun 2007 22:40:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Hartmut Birr <e9hack@googlemail.com>, Georg Acher <acher@in.tum.de>,
       Oliver Endriss <o.endriss@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: drivers/media/dvb/frontends/tda10023.c: buggy (dead) code
Message-ID: <20070615204047.GI3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following buggy code in 
drivers/media/dvb/frontends/tda10023.c:

<--  snip  -->

...
#define XTAL   28920000UL
#define PLL_M  8UL
#define PLL_P  4UL
#define PLL_N  1UL
#define SYSCLK (XTAL*PLL_M/(PLL_N*PLL_P))  // -> 57840000
...
static int tda10023_set_symbolrate (struct tda10023_state* state, u32 sr)
{
...
        if (sr<870000)
                sr=870000;

        if (sr < (u32)(SYSCLK/98.40)) {
                NDEC=3;
                SFIL=1;
        } else if (sr<(u32)(SYSCLK/64.0)) {
                NDEC=3;
                SFIL=0;
        } else if (sr<(u32)(SYSCLK/49.2)) {
                NDEC=2;
                SFIL=1;
        } else if (sr<(u32)(SYSCLK/32.0)) {
                NDEC=2;
                SFIL=0;
        } else if (sr<(u32)(SYSCLK/24.6)) {
                NDEC=1;
                SFIL=1;
        } else if (sr<(u32)(SYSCLK/16.0)) {
                NDEC=1;
                SFIL=0;
        } else if (sr<(u32)(SYSCLK/12.3)) {
                NDEC=0;
                SFIL=1;
        }
...
}
...

<--  snip  -->


57840000 / 98.40 = 587804 < 870000


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

