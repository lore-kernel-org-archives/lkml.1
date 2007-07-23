Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbXGWAzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbXGWAzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXGWAz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:55:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41520 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757657AbXGWAz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:55:28 -0400
Date: Mon, 23 Jul 2007 02:54:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: drivers/hwmon/lm93.c: array overruns
Message-ID: <20070723005453.GS26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following array overruns
in drivers/hwmon/lm93.c:

<--  snip  -->

...
struct lm93_data {
...
        struct {
                u8 min;
                u8 max;
        } temp_lim[3];
...
};
...
static void lm93_update_client_common(struct lm93_data *data,
                                      struct i2c_client *client)
{
...
        for (i = 0; i < 4; i++) {
                data->temp_lim[i].min =
                        lm93_read_byte(client, LM93_REG_TEMP_MIN(i));
                data->temp_lim[i].max =
                        lm93_read_byte(client, LM93_REG_TEMP_MAX(i));
        }
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

