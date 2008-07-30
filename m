Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbYG3AOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbYG3AOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYG3AOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:14:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38530 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYG3AOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:14:05 -0400
Date: Wed, 30 Jul 2008 02:13:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call IPIs
Message-ID: <20080730001358.GA23938@one.firstfloor.org>
References: <488FA8A9.6000005@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488FA8A9.6000005@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 04:32:57PM -0700, Jeremy Fitzhardinge wrote:
> This adds 8 queues for smp_call_function(), in order to avoid a

Now that we have per CPU IDT and there's no global bottleneck anymore
I think it would be actually fine to use
more than 8 vectors. 32 or 64 might be a better default.

> void native_send_call_func_ipi(cpumask_t mask)
> {
> 	cpumask_t allbutself;
> +	unsigned queue = smp_processor_id() % CONFIG_GENERIC_SMP_QUEUES;

Does this really always run with preemption disabled?

Did I miss it but where is the per vector lock? 

-Andi
