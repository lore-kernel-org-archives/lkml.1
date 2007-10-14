Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXJNRuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXJNRuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbXJNRu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:50:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35243 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759886AbXJNRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:50:26 -0400
Date: Sun, 14 Oct 2007 19:50:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Patrick Boettcher <pboettcher@dibcom.fr>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: DVB: BANDWIDTH_TO_KHZ strangeness
Message-ID: <20071014175055.GJ4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/dvb/frontends/dibx000_common.h contains:

<--  snip  -->

...
#define BANDWIDTH_TO_KHZ(v) ( (v) == BANDWIDTH_8_MHZ  ? 8000 : \
                             (v) == BANDWIDTH_7_MHZ  ? 7000 : \
                             (v) == BANDWIDTH_6_MHZ  ? 6000 : 8000 )
...

<--  snip  -->


Commit b6884a17fc70e979ef34e4b5560988b522bb50a0 added to both of 
drivers/media/dvb/frontends/dib7000{m,p}.c:

<--  snip  -->

...
        factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
        if (factor >= 5000)
                factor = 1;
        else
                factor = 6;
...

<--  snip  -->


factor < 5000 is obviously never possible.

drivers/media/dvb/frontends/dib0070.c contains a similar assumption that 
BANDWIDTH_TO_KHZ() could result in values other than {6,7,8}000
(I haven't checked whether there are more such assumptions in other 
places).

Spotted by the Coverity checker.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

