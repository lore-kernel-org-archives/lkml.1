Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXJPKeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXJPKeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXJPKd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:33:56 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:39865 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbXJPKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:33:55 -0400
Date: Tue, 16 Oct 2007 12:33:54 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Nick Piggin <npiggin@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
In-Reply-To: <20071016002229.GA5851@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
 <20071016002229.GA5851@wotan.suse.de>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, Nick Piggin wrote:

> > > The cpus also have an explicit set of instructions that deliberately do 
> > > unordered stores/loads, and s/lfence etc are mostly designed for those.
> > 
> > I know about unordered stores (movnti & similar) --- they basically use 
> > write-combining method on memory that is normally write-back --- and they 
> > need sfence. But which one instruction does unordered load and needs 
> > lefence?
> 
> Also, for non-wb memory. I don't think the Intel document referenced
> says anything about this, but the AMD document says that loads can pass
> loads (page 8, rule b).
> 
> This is why our rmb() is still an lfence.

I see, AMD says that WC memory loads can be out-of-order.

There is very little usability to it --- framebuffer and AGP aperture is 
the only piece of memory that is WC and no kernel structures are placed 
there, so it is possible to remove that lfence.

Mikulas
