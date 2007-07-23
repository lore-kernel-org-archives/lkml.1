Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXGWApe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXGWApe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764955AbXGWAo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:44:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41512 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762152AbXGWAo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:44:57 -0400
Date: Mon, 23 Jul 2007 02:44:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rodolfo Giometti <giometti@linux.it>,
       David Brownell <dbrownell@users.sourceforge.net>, a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: rtc-ds1307.c: array overrun
Message-ID: <20070723004422.GR26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following array overrun
in drivers/rtc/rtc-ds1307.c:

<--  snip  -->

...
#define DS1337_REG_CONTROL      0x0e
...
struct ds1307 {
        u8                      reg_addr;
        u8                      regs[8];
...
};
...
static int __devinit ds1307_probe(struct i2c_client *client)
{
...
                                        ds1307->regs[DS1337_REG_CONTROL]
...

<--  snip  -->


0x0e > 8


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

