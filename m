Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYEWMvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYEWMvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYEWMvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:51:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:41989 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYEWMvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:51:11 -0400
Subject: Re: MMIO and gcc re-ordering (Was: [PATCH] [POWERPC] Improve
	(in|out)_beXX() asm code)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1211546197.8297.308.camel@pasglop>
References: <4833524C.3040207@freescale.com>
	 <20080520.153947.84346222.davem@davemloft.net>
	 <4833542E.3040608@freescale.com>
	 <20080520.155326.195407196.davem@davemloft.net>
	 <1211516683.8297.271.camel@pasglop>
	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
	 <1211546197.8297.308.camel@pasglop>
Content-Type: text/plain
Date: Fri, 23 May 2008 08:50:16 -0400
Message-Id: <1211547016.8297.310.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 08:36 -0400, Benjamin Herrenschmidt wrote:
> 
>         - mandate some kind of dma_sync_for_device/cpu on consistent memory.
> Almost no driver do that currently tho. They only do that for non
> consistent memory mapped with dma_map_*.
> 
>         - mandate the use of wmb,rmb,mb barriers for use between memory
> accesses and MMIOs for ordering them. (ie. fix drivers that don't do
> it). Advantage for powerpc is that I can remove (after some auditing of
> course) the added heavy barriers in the MMIO accessors themselves.

Note that the above is my preferred approach, and a lot of drivers
happen to already do this.

>         - stick a full memory clobber in all MMIO (and PIO) accessors on all
> archs.
> 
> Any other idea ? preference ?

