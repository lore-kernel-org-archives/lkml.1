Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbYJGO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbYJGO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJGO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:27:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbYJGO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:27:42 -0400
Message-ID: <48EB7192.6090307@linux-foundation.org>
Date: Tue, 07 Oct 2008 09:26:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Matt Mackall <mpm@selenic.com>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SLOB's krealloc() seems bust
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>	 <48EB6D2C.30806@linux-foundation.org> <1223388788.26330.38.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223388788.26330.38.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> kernel/module.c: perpcu_modinit() reads:
> 
> 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
> 			    GFP_KERNEL);
> 
> kernel/module.c: split_block() reads:
> 
> 		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
> 			       GFP_KERNEL);
> 

That code is on the way out btw. cpu_alloc support removes this code.
