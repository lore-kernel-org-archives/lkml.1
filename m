Return-Path: <linux-kernel-owner+w=401wt.eu-S1763830AbXGPV4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763830AbXGPV4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbXGPV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:56:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36946 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761795AbXGPV42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:56:28 -0400
Message-ID: <469BE988.6090907@pobox.com>
Date: Mon, 16 Jul 2007 17:56:24 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 free_shared_mem() in drivers/net/s2io.c
References: <aaab98560707082029u52ffce5eia32cfb57a29db78f@mail.gmail.com>
In-Reply-To: <aaab98560707082029u52ffce5eia32cfb57a29db78f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference
> nic before a null check. This patch simply moves the dereferencing
> after the null check.
> 
> Signed-off-by: Micah Gruber < micah.gruber@gmail.com>
> 
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -789,12 +789,14 @@
>        struct mac_info *mac_control;
>        struct config_param *config;
>        int lst_size, lst_per_page;
> -       struct net_device *dev = nic->dev;
> +       struct net_device *dev;
>        int page_num = 0;
> 
>        if (!nic)
>                return;
> 
> +       dev = nic->dev;
> +

applied manually -- all of your patch attempts produced corrupted patches :/


