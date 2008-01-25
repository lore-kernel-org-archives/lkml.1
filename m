Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYAYKl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYAYKl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYAYKlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:41:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYAYKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:41:18 -0500
Date: Fri, 25 Jan 2008 11:41:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Minoru Usui <usui@mxm.nes.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, magnus.damm@gmail.com
Subject: Re: [PATCH] Fix NUMA emulation for x86_64
Message-ID: <20080125104107.GS23708@elte.hu>
References: <20080125.171613.41631926.usui@mxm.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125.171613.41631926.usui@mxm.nes.nec.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Minoru Usui <usui@mxm.nes.nec.co.jp> wrote:

> I found a small bug of NUMA emulation code for x86_64. 
> (CONFIG_NUMA_EMU) If machine is non-NUMA, find_node_by_addr() should 
> return NUMA_NO_NODE, but current implementation code returns existent 
> maximum NUMA node number + 1. This is not existent NUMA node number.
>
> However, this behaviour does not affect NUMA emulation fortunately, 
> because acpi_fake_nodes() that is caller of find_node_by_addr() gets 
> pxm (proximity domain) by node_to_pxm() from non-existent NUMA node 
> number that was returned by find_node_by_addr(). node_to_pxm() returns 
> PXM_INVAL that means illegal or non-existent NUMA node number.

thanks, i have applied your fix to x86.git.

It seems this does not need to be backported to v2.6.24.1 because 
node_to_pxm() masked the bad effects of this bug, right?

	Ingo
