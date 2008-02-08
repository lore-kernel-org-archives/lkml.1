Return-Path: <linux-kernel-owner+w=401wt.eu-S964939AbYBHLkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939AbYBHLkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYBHLko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:40:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYBHLkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:40:43 -0500
Date: Fri, 8 Feb 2008 13:15:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208121550.GG4745@one.firstfloor.org>
References: <47AB79D4.2070605@gmail.com> <20080208115542.GD4745@one.firstfloor.org> <84144f020802080337h5179210era890cf9b4e19c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802080337h5179210era890cf9b4e19c35@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 01:37:11PM +0200, Pekka Enberg wrote:
> Hi Andi,
> 
> On Feb 8, 2008 1:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Also i'm not sure how you handle initializedness of DMAed data
> > (like network buffers). Wouldn't you need hooks into pci_dma_*
> > for this?
> 
> If the DMA'd memory is allocated from the page allocator, we don't

RX Network packets are usually allocated with kmalloc

Undoubtedly there are others too, e.g. USB comes to mind.

> need to worry about it just yet. In case it's from kmalloc() you can
> pass __GFP_NOTRACK to annotate those call sites where the memory is

Ok you should add that then to skbuff.c. 

-Andi
