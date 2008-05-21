Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbYEUOBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbYEUOBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762905AbYEUOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:01:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:56895 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764111AbYEUOBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:01:42 -0400
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805201535290.7453@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	 <1211318219.8297.177.camel@pasglop> <483344C0.3020703@freescale.com>
	 <20080520231516.76b924a2@core> <4833524C.3040207@freescale.com>
	 <Pine.LNX.4.64.0805201535290.7453@t2.domain.actdsltmp>
Content-Type: text/plain
Date: Wed, 21 May 2008 10:01:22 -0400
Message-Id: <1211378482.8297.193.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 15:55 -0700, Trent Piepho wrote:
> here doesn't appear to be any barriers to use for coherent dma other than
> mb() and wmb().
> 
> Correct me if I'm wrong, but I think the sync isn't actually _required_ (by
> memory-barriers.txt's definitions), and it would be enough to use eieio,
> except there is code that doesn't use mmiowb() between I/O access and
> unlocking.
> 
> So, as I understand it, the minimum needed is eieio.  To provide strict
> ordering w.r.t. spin locks without using mmiowb(), you need sync.  To provide
> strict ordering w.r.t. normal memory, you need sync and a compiler barrier.
> 
> Right now no archs provide the last option.  powerpc is currently the middle
> option.  I don't know if anything uses the first option, maybe alpha?  I'm
> almost certain x86 is the middle option (the first isn't possible, the arch
> already has more ordering than that), which is probably why powerpc used that
> option and not the first.

I don't have time for that now. Can you dig into the archives ? The
whole thing has been discussed at lenght already.

Ben.

