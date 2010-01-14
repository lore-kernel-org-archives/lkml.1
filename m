Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381Ab0ANRbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0ANRbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363Ab0ANRa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:30:59 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:39912 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757364Ab0ANRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:30:58 -0500
Date: Thu, 14 Jan 2010 18:30:54 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparc: leds_resource.end assigned to itself in
 clock_board_probe()
Message-ID: <20100114183054.0b53c351@taxman.wild-wind.fr.eu.org>
In-Reply-To: <4B4F4C9B.9040202@gmail.com>
References: <4B4F4C9B.9040202@gmail.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 83.161.227.188
X-SA-Exim-Rcpt-To: roel.kluin@gmail.com, davem@davemloft.net, sparclinux@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 17:55:55 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> These statements appear redundant.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is there any reason to assign this to itself?
> 
> diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
> index f3b5466..773caf4 100644
> --- a/arch/sparc/kernel/central.c
> +++ b/arch/sparc/kernel/central.c
> @@ -99,7 +99,6 @@ static int __devinit clock_board_probe(struct
> of_device *op, 
>  	p->leds_resource.start = (unsigned long)
>  		(p->clock_regs + CLOCK_CTRL);
> -	p->leds_resource.end = p->leds_resource.end;

I have the feeling that the right fix is to have:

	p->leds_resource.end = p->leds_resource.start;

hence describing a 1 byte region.

	M.
-- 
I'm the slime oozin' out from your TV set...
