Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYGGMtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYGGMtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYGGMtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:49:36 -0400
Received: from styx.suse.cz ([82.119.242.94]:32884 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbYGGMtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:49:35 -0400
Date: Mon, 7 Jul 2008 14:49:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Darren Jenkins\\" <darrenrjenkins@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] drivers/char/pcmcia/ipwireless/hardware.c fix resource
 leak
In-Reply-To: <1215382690.11092.11.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0807071447470.3141@jikos.suse.cz>
References: <1215382690.11092.11.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-115667014-1215434974=:3141"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-115667014-1215434974=:3141
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 7 Jul 2008, Darren Jenkins\ wrote:

> G'day people,
>
> Coverity CID: 2172 RESOURCE_LEAK
>
> When pool_allocate() tries to enlarge a packet, if it can not allocate
> enough memory, it returns NULL without first freeing the old packet.
>
> This patch just frees the packet first.
>
> ﻿﻿﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
>
> diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
> index ba6340a..929101e 100644
> --- a/drivers/char/pcmcia/ipwireless/hardware.c
> +++ b/drivers/char/pcmcia/ipwireless/hardware.c
> @@ -590,8 +590,10 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
> 		packet = kmalloc(sizeof(struct ipw_rx_packet) +
> 				old_packet->length + minimum_free_space,
> 				GFP_ATOMIC);
> -		if (!packet)
> +		if (!packet) {
> +			kfree(old_packet);
> 			return NULL;
> +		}
> 		memcpy(packet, old_packet,
> 				sizeof(struct ipw_rx_packet)
> 					+ old_packet->length);
>
>
>

Thanks a lot for reporting this, Darren.

Andrew, could you please push this through -mm? Thanks.


 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
--336216065-115667014-1215434974=:3141--
