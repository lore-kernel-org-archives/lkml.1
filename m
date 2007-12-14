Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXLNU2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXLNU2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXLNU1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:27:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43009 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbXLNU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:27:54 -0500
Message-ID: <4762E746.8050405@pobox.com>
Date: Fri, 14 Dec 2007 15:27:50 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/sis190.c section fix
References: <20071211222356.GA14204@stusta.de>
In-Reply-To: <20071211222356.GA14204@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.init.text.20+0x4cb25): Section mismatch: reference to .exit.text:sis190_mii_remove (between 'sis190_init_one' and 'read_eeprom')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 29fae057ba15a552a7cad1e731d3238d567032ba 
> diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
> index 7200883..49f767b 100644
> --- a/drivers/net/sis190.c
> +++ b/drivers/net/sis190.c
> @@ -1381,7 +1381,7 @@ out:
>  	return rc;
>  }
>  
> -static void __devexit sis190_mii_remove(struct net_device *dev)
> +static void sis190_mii_remove(struct net_device *dev)
>  {
>  	struct sis190_private *tp = netdev_priv(dev);
>  
> 

applied #upstream-fixes


