Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZFHJKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZFHJKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZFHJKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:10:37 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49106 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZFHJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:10:37 -0400
Message-ID: <4A2CD560.8070002@s5r6.in-berlin.de>
Date: Mon, 08 Jun 2009 11:09:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Pranith Kumar <pranith.hacks@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <4A2CBB99.9080908@gmail.com> <4A2CC6FA.6020904@gmail.com>
In-Reply-To: <4A2CC6FA.6020904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar wrote:
> @@ -629,7 +629,7 @@ void  update_os_packet_info(
>  	pOSPkt->dev = get_netdev_from_bssid(pAd, FromWhichBSSID);
>  	pOSPkt->data = pRxBlk->pData;
>  	pOSPkt->len = pRxBlk->DataSize;
> -	pOSPkt->tail = pOSPkt->data + pOSPkt->len;
> +	pOSPkt->tail = (UCHAR *) (pOSPkt->data + pOSPkt->len);
>  }
>  
>  

This is what I meant with "a warning should stay there as long as the
underlying problem isn't fixed".

This code uses defined types which are foreign to Linux.  We don't
define UCHAR in Linux.  /This/ needs to be fixed in the entire driver.
Until this is not done, there is no reason to add this pointer type cast
merely to quieten gcc.
-- 
Stefan Richter
-=====-==--= -==- -=---
http://arcgraph.de/sr/
