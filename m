Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZEVIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZEVIQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZEVIQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:16:11 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:61993 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZEVIQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:16:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 10:16:09 +0200
Message-Id: <1242980169.26820.617.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> Since we don't have individual fds for the counters in a cloned
> context, the only thing that can make two clones of a given parent
> different after they have been cloned is enabling or disabling all
> counters with prctl.  To account for this, we keep a count of the
> number of enabled counters in each context.  Two contexts must have
> the same number of enabled counters to be considered equivalent.

Curious point that.. so prctl() can disable counters it doesn't own.

Shouldn't we instead fix that?

