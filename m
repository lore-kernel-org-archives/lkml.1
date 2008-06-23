Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYFWPJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYFWPJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYFWPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:09:44 -0400
Received: from relais.videotron.ca ([24.201.245.36]:31344 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYFWPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:09:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 23 Jun 2008 11:09:41 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sdio: bad CISTPL_FUNCE error
In-reply-to: <485FAF34.8000609@atmel.com>
Message-id: <alpine.LFD.1.10.0806231059250.2979@xanadu.home>
References: <485BCBB3.20405@atmel.com>
 <alpine.LFD.1.10.0806211045390.2979@xanadu.home> <485FAF34.8000609@atmel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Nicolas Ferre wrote:

> Here is the log :
> mmc0: bad function CISTPL_FUNCE size 28 type 1

If you look in cistpl_funce_func() you'll find this code:

        vsn = func->card->cccr.sdio_vsn;
        min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
        if (size < min_size || buf[0] != 1)
                return -EINVAL;

I suspect your card might be buggy wrt the SDIO standard.

You could try printing out the value of vsn here, and then hardcode it 
to SDIO_SDIO_REV_1_00 to see if that helps.


Nicolas
