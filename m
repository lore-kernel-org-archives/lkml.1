Return-Path: <linux-kernel-owner+w=401wt.eu-S1765815AbYA2UB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765815AbYA2UB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbYA2UBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:01:02 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37024 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758375AbYA2UA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:00:59 -0500
Message-ID: <479F85F9.3040104@sgi.com>
Date: Tue, 29 Jan 2008 12:00:57 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, jeremy@goop.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] percpu: Optimize percpu accesses
References: <20080123044924.508382000@sgi.com> <20080124224613.GA24855@elte.hu>
In-Reply-To: <20080124224613.GA24855@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> 
> tried it on x86.git and 1/3 did not build and 2/3 causes a boot hang 
> with the attached .config.
> 
> 	Ingo
> 

I've tracked down the failure to an early printk that when CONFIG_PRINTK_TIME
is enabled, any early printks cause cpu_clock to be called, which accesses
cpu_rq which is defined as:

 595 #define cpu_rq(cpu)             (&per_cpu(runqueues, (cpu)))

Since the zero-based patch is changing the offset from one based on
__per_cpu_start to zero, it's causing the function to access a
different area.

I'm working on a fix now.

Thanks,
Mike
