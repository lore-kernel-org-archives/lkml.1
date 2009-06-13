Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZFMJSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZFMJSK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 05:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFMJR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 05:17:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34529 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZFMJR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 05:17:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.28357.164575.925080@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 19:17:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf_counters: page fault trace record
In-Reply-To: <4A336700.3060309@linux.vnet.ibm.com>
References: <4A330022.3070105@linux.vnet.ibm.com>
	<18995.8319.322002.917595@cargo.ozlabs.ibm.com>
	<4A336700.3060309@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> Paul Mackerras wrote:
> > Can't you do what you need just using a page fault software counter
> > with sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_ADDR and
> > sample_period = 1?
> 
> I thought about that, but I was under the (incorrect?) impression that 
> on Power, the PERF_SAMPLE_ADDR would be set by the value of the SDAR 
> register, which wouldn't be correct for the case of a page fault.

No, the PERF_SAMPLE_ADDR value only comes from SDAR for a hardware
counter overflow event.  For the page-fault software counter the
PERF_SAMPLE_ADDR value will always be the faulting address.

Paul.
