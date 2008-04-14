Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbYDNRzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbYDNRzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbYDNRy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:54:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51314 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbYDNRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:54:54 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <87d4osuy6r.fsf@basil.nowhere.org>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org>
	 <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org>
	 <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org>
	 <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>
	 <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 19:54:33 +0200
Message-Id: <1208195673.7164.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 19:46 +0200, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> >
> > Yeah, I would open code it.  But this is indeed a sane usage of the
> > counting semaphore because there is no priority inversion.
> 
> But when you open code that, how is it different from just having
> semaphores? 

Because we can then eventually get rid of semaphores, so those people
cannot mistakenly use them. Its just too easy to create prio inversion
with them around.

