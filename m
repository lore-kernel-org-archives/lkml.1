Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYDNQdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYDNQdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYDNQdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:33:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57604 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYDNQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:33:01 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <adafxtoqvgh.fsf@cisco.com>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org>
	 <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org>
	 <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org>
	 <20080414153928.GA22259@elte.hu>  <adafxtoqvgh.fsf@cisco.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 18:32:28 +0200
Message-Id: <1208190749.7375.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 08:58 -0700, Roland Dreier wrote:
> > which ones exactly are these places that demand the use of a counting 
>  > semaphore? I cannot think of a single place where it's the best choice, 
>  > let alone one where it's the only choice.
> 
> Two of the places that use semaphores are drivers/infiniband/hw/mthca
> and drivers/net/mlx4 -- in both cases, the device firmware allows up to
> "N" outstanding firmware commands to be in flight, and the driver uses a
> semaphore to handle issuing firmware commands.  That is, down() when we
> want to issue a command, and up() when the firmware responds that the
> command is complete.
> 
> What would you suggest as a better way to code this?  This is an honest
> question -- there probably is a more elegant way to handle this
> situation and I really would like to learn about it.
> 
> Also, the argument that removing semaphores makes the kernel as a whole
> better does make sense to me; I wouldn't be opposed to basically
> open-coding semaphores in terms of wait_event() in the driver or
> something like that, but I wouldn't say that such an implementation is
> locally more readable or maintainable if we look only at the driver
> code.

Yeah, I would open code it.  But this is indeed a sane usage of the
counting semaphore because there is no priority inversion.

