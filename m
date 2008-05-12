Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYELNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYELNKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYELNKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:10:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44706 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYELNKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:10:20 -0400
Subject: Re: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected if
	built in Bluetooth CF driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <1210587779-10257-1-git-send-email-cooloney@kernel.org>
References: <1210587779-10257-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 15:10:28 +0200
Message-Id: <1210597828.16390.44.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2650
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/bluetooth/bluecard_cs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
> index bcf5792..3b330a0 100644
> --- a/drivers/bluetooth/bluecard_cs.c
> +++ b/drivers/bluetooth/bluecard_cs.c
> @@ -867,7 +867,7 @@ static int bluecard_probe(struct pcmcia_device *link)
>  
>  	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
>  	link->io.NumPorts1 = 8;
> -	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
> +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
>  	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
>  
>  	link->irq.Handler = bluecard_interrupt;

all Bluetooth PCMCIA drivers use an exclusive IRQ:

bluecard_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
bt3c_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
btuart_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
dtl1_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;

There was a reason for that when these drivers where written. I am not
sure if it is still valid or not. Does anybody at least have tested that
the cards still work if you use a shared IRQ.

Regards

Marcel


