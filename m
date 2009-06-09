Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZFIEef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZFIEef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZFIEe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:34:26 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57039 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZFIEe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:34:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18989.57919.895309.847520@drongo.ozlabs.ibm.com>
Date: Tue, 9 Jun 2009 14:17:03 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
In-Reply-To: <1244481941.13761.9119.camel@twins>
References: <1244481941.13761.9119.camel@twins>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Allow extending the perf_counter_attr structure by linking extended
> structures to it.

...

> @@ -175,6 +175,13 @@ struct perf_counter_attr {
>  	__u32			__reserved_3;
>  
>  	__u64			__reserved_4;
> +
> +	struct perf_counter_attr_ext *ext_attrs;
> +};

Since this is a user-visible structure, you've just introduced an ABI
difference between 32-bit and 64-bit processes, which we've managed to
avoid so far.  Assuming that is that you intend eventually to use the
value that userspace puts there, which you don't at the moment.  Was
that your intention?

Paul.
