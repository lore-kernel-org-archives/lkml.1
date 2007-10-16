Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXJPKSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXJPKSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXJPKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:17:53 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:33182 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122AbXJPKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:17:52 -0400
Date: Tue, 16 Oct 2007 12:17:51 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
In-Reply-To: <471401AF.4090802@zytor.com>
Message-ID: <Pine.LNX.4.64.0710161205160.1315@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <471401AF.4090802@zytor.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, H. Peter Anvin wrote:

> Mikulas Patocka wrote:
> > 
> > I know about unordered stores (movnti & similar) --- they basically use
> > write-combining method on memory that is normally write-back --- and they
> > need sfence. But which one instruction does unordered load and needs
> > lefence?
> > 
> 
> PREFETCHNTA.

PREFETCH* doesn't change program semantics. The processor is allowed to 
ignore prefetch instruction if it doesn't have resources needed for 
prefetch. It not ordered wrt. fences.

PREFETCHNTA was implemented as prefetch into L1 cache and omitting L2 
cache on Pentium 3 and M --- and it is implemented as prefetch into L2 
cache on other --- do it doesn't really use any special buffers.

Mikulas

> 	-hpa
> 
