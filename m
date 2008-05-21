Return-Path: <linux-kernel-owner+w=401wt.eu-S937688AbYEUUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937688AbYEUUlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937637AbYEUUl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:41:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:47678 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937631AbYEUUlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:41:25 -0400
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Trent Piepho <tpiepho@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
In-Reply-To: <Pine.LNX.4.64.0805211238440.5706@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	 <1211318219.8297.177.camel@pasglop>
	 <Pine.LNX.4.64.0805201425250.7453@t2.domain.actdsltmp>
	 <1211378410.8297.192.camel@pasglop>
	 <Pine.LNX.4.64.0805211238440.5706@t2.domain.actdsltmp>
Content-Type: text/plain
Date: Wed, 21 May 2008 16:41:12 -0400
Message-Id: <1211402472.8297.244.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-21 at 12:44 -0700, Trent Piepho wrote:
> 
> Someone should update memory-barriers.txt, because it doesn't say
> that, and
> all I/O accessors for all the arches, because none of them are.

There have been long discussions about that. The end result was that
being too weakly ordered is just asking for trouble because the majority
of drivers are written & tested on x86 which is in order.

If you look at our accessors, minus that gcc problem you found, the
barriers in there should pretty much guarantee ordering in the cases
that matter, which are basically MMIO read followed by memory accesses
and memory writes followed by MMIO. In fact, MMIO read are fully
sychronous.

> No, it's compiled with a normal kernel build, which includes
> -fno-strict-aliasing

Ok, so there is a very bad bug indeed, we need to fix that.

Ben.


