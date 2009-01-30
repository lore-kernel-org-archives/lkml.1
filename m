Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbZA3Xim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbZA3Xim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZA3Xif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:38:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZA3Xie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:38:34 -0500
Message-ID: <49838F39.6060603@zytor.com>
Date: Fri, 30 Jan 2009 15:37:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Martin Hicks <mort@sgi.com>
CC: tglx@linutronix.de, mingo@redhat.com, heukelum@mailshack.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
References: <20090130165053.GE7872@alcatraz.americas.sgi.com>
In-Reply-To: <20090130165053.GE7872@alcatraz.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Hicks wrote:
> Hi,
> 
> KDB was using this information.  Could this be pushed towards 2.6.29 please?
> 
> This re-adds the old stack pointer to the top of the irqstack to help
> with unwinding.  It was removed in commit d99015b1abbad743aa049b439c1e1dede6d0fa49
> as part of the save_args out-of-line work.
> 

This bothers me... why should we add even a single instruction to what 
is arguably the single hottest path in the kernel to support an 
out-of-tree debugger, especially if kgdb (which is in-tree) doesn't need it?

What does kgdb do differently (or is kgdb broken too)?

	-hpa
