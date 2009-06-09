Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbZFIJ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbZFIJ6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbZFIJ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:58:14 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48561 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650AbZFIJ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:58:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18990.12846.941708.201337@cargo.ozlabs.ibm.com>
Date: Tue, 9 Jun 2009 19:58:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
In-Reply-To: <20090609065350.GB16707@elte.hu>
References: <1244481941.13761.9119.camel@twins>
	<18989.57919.895309.847520@drongo.ozlabs.ibm.com>
	<20090609065350.GB16707@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:

> > Since this is a user-visible structure, you've just introduced an 
> > ABI difference between 32-bit and 64-bit processes, which we've 
> > managed to avoid so far. [...]
> 
> This is a good point too - handling pointers in ABIs is possible but 
> should be avoided as much as possible: it creates the need to 
> introduce a compat_sys_perf_counter_open() and doubles the syscall 
> table complexity.
> 
> Lets do the s/__reserved_1/attr_size ABI i suggested (i outlined 
> various properties of it in the previous mail). Agreed?

Yep, sounds good.

We also need a way to allow access to random machine-specific features
that might not be supported in a generic way, such as the instruction
matching CAM on POWER4/PPC970, or (apparently) PEBS.  That's what I
had intended exclusive groups + the extra_config_len field to be used
for, but Peter removed extra_config_len...

Paul.
