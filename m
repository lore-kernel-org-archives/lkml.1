Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYFVNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYFVNec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 09:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFVNeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 09:34:22 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:9990 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYFVNeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 09:34:22 -0400
X-ME-UUID: 20080622133419525.8055E7000089@mwinf2a14.orange.fr
Message-ID: <485E54DB.6060804@wanadoo.fr>
Date: Sun, 22 Jun 2008 15:34:19 +0200
From: JAILLET <jaillet.christophe@wanadoo.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: petero2@telia.com, linux <linux-kernel@vger.kernel.org>,
       cj <jaillet.christophe@wanadoo.fr>
Subject: [PATCH 1/1] drivers/block/pktcdvd.c : avoid useless memset
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>

Hi, here is a patch against linux/drivers/block/pktcdvd.c which :

1) Avoid to 'memset(...,0, ...)' before calling 'init_cdrom_command' 
because this function already does it.


Signed-off-by: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>

---
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3ba1df9..8369ebc 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2079,7 +2079,6 @@ static noinline_for_stack int 
pkt_write_caching(struct pktcdvd_device *pd,
unsigned char buf[64];
int ret;

- memset(buf, 0, sizeof(buf));
init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
cgc.sense = &sense;
cgc.buflen = pd->mode_offset + 12;
@@ -2126,7 +2125,6 @@ static noinline_for_stack int 
pkt_get_max_speed(struct pktcdvd_device *pd,
unsigned char *cap_buf;
int ret, offset;

- memset(buf, 0, sizeof(buf));
cap_buf = &buf[sizeof(struct mode_page_header) + pd->mode_offset];
init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_UNKNOWN);
cgc.sense = &sense;


