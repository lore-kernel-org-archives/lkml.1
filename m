Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZKCOAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZKCOAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZKCOAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:00:05 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:55038 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZKCOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:00:04 -0500
Message-ID: <4AF03720.5070506@csr.com>
Date: Tue, 03 Nov 2009 13:58:56 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, Alan Cox <alan@linux.intel.com>,
       linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
References: <20091102164039.11877.88825.stgit@localhost.localdomain>	<alpine.LFD.2.00.0911021243040.13333@xanadu.home>	<20091102191604.010acbc9@lxorguk.ukuu.org.uk>	<alpine.LFD.2.00.0911021542520.13333@xanadu.home> <20091103120618.26b669be@lxorguk.ukuu.org.uk>
In-Reply-To: <20091103120618.26b669be@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2009 13:58:56.0960 (UTC) FILETIME=[C9394C00:01CA5C8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> The claim method takes the mutex, checks if it is NULL and acts
> accordingly but it releases the mutex, which makes it useless as the code
> then uses port->func. If I move the release of the mutex to the
> release_func method then that fixes almost all cases.
> 
> The one I'm stuck on is this
> 
> 
> 		CPU1				CPU2
> 
> 
> 	sdio_uart_irq
> 					sdio_uart_port_remove
> 					port->func = NULL;
> 	sdio_in
> 	BUG_ON

This is actually happening?  sdio_claim_host()/sdio_release_host() act
like a mutex so sdio_uart_port_remove() will wait in sdio_claim_host()
until sdio_uart_irq() returns (SDIO interrupt handlers are called with
the host claimed).

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
