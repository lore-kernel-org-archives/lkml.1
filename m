Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYFVQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYFVQaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYFVQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:30:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49148 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYFVQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:30:28 -0400
Date: Sun, 22 Jun 2008 09:26:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: JAILLET <jaillet.christophe@wanadoo.fr>
Cc: petero2@telia.com, linux <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers/block/pktcdvd.c : avoid useless memset
Message-Id: <20080622092655.27b2c388.randy.dunlap@oracle.com>
In-Reply-To: <485E54DB.6060804@wanadoo.fr>
References: <485E54DB.6060804@wanadoo.fr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 15:34:19 +0200 JAILLET wrote:

> From: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/block/pktcdvd.c which :
> 
> 1) Avoid to 'memset(...,0, ...)' before calling 'init_cdrom_command' 
> because this function already does it.
> 
> 
> Signed-off-by: Christophe Jaillet <jaillet.﻿christophe@wanadoo.fr>
> 
> ---
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 3ba1df9..8369ebc 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2079,7 +2079,6 @@ static noinline_for_stack int 
> pkt_write_caching(struct pktcdvd_device *pd,
> unsigned char buf[64];
> int ret;
> 
> - memset(buf, 0, sizeof(buf));
> init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
> cgc.sense = &sense;
> cgc.buflen = pd->mode_offset + 12;
> @@ -2126,7 +2125,6 @@ static noinline_for_stack int 
> pkt_get_max_speed(struct pktcdvd_device *pd,
> unsigned char *cap_buf;
> int ret, offset;
> 
> - memset(buf, 0, sizeof(buf));
> cap_buf = &buf[sizeof(struct mode_page_header) + pd->mode_offset];
> init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_UNKNOWN);
> cgc.sense = &sense;

Looks like tbird ate all of the whitespace.
You can see if Documentation/email-clients.txt has info in it that
would help you, then resend the patch.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
