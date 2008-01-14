Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYANQxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYANQxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYANQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:52:58 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:56091 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYANQw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:52:57 -0500
Date: Mon, 14 Jan 2008 11:52:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>
cc: Mike Galbraith <efault@gmx.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt1
In-Reply-To: <200801142039.42463.caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.58.0801141151550.7083@gandalf.stny.rr.com>
References: <1200250801.9190.7.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
 <1200299260.4665.17.camel@homer.simson.net> <200801142039.42463.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jan 2008, [utf-8] S.Ã^GaÄ^_lar Onur wrote:

>
> Following seems solves this issue;
>
> Index: linux-2.6.23/drivers/dma/ioat_dma.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/dma/ioat_dma.c
> +++ linux-2.6.23/drivers/dma/ioat_dma.c
> @@ -260,7 +260,7 @@ static dma_cookie_t ioat1_tx_submit(stru
>  	/* write address into NextDescriptor field of last desc in chain */
>  	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
>  							first->async_tx.phys;
> -	__list_splice(&new_chain, ioat_chan->used_desc.prev);
> +	list_splice(&new_chain, &ioat_chan->used_desc);

Thanks, but I already fixed it. It requires a list_splice_tail.

-- Steve

>
>  	ioat_chan->dmacount += desc_count;
>  	ioat_chan->pending += desc_count;
>
>

