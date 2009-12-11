Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbZLKLsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbZLKLsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbZLKLsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:48:08 -0500
Received: from mail2.picochip.com ([82.111.145.34]:53572 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762303AbZLKLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:48:08 -0500
Date: Fri, 11 Dec 2009 11:48:58 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, jamie.iles@picochip.com,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       peterz@infradead.org
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211114858.GE4164@wear.picochip.com>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com> <20091211102316.GB16882@elte.hu> <20091211.023808.233094506.davem@davemloft.net> <20091211104126.GA22079@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211104126.GA22079@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 11:47:43 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 11:41:26AM +0100, Ingo Molnar wrote:
> > I think he did it this way so it can compile in the meantime, and that 
> > doing it right requires runtime cpu detection to select which barrier 
> > instruction is even available on the current ARM cpu.
> 
> Yeah. We can merge a quick patch for it if runtime detection is 
> difficult - but if then such a patch should err on the side of using the 
> barrier instruction unconditionally - even if this causes perf to 
> segfault on certain (older? UP configured?) ARM cores.
Ok, unless anyone has any objections, I'll post a revised patch that uses the
MCR instruction so that we get the correct behaviour on v6/v7 SMP and UP
systems and an illegal instruction on v5 or earlier. I've had a quick look at
runtime detection and the ID registers are only accessible from privileged
modes so for long term, it might be better to define the rmb() at build time
from the kernel config.

Jamie
