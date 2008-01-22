Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYAVLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYAVLXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYAVLXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:23:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38123 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYAVLXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:23:16 -0500
Date: Tue, 22 Jan 2008 12:22:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: fix early cpu_to_node panic from
	nr_free_zone_pages
Message-ID: <20080122112257.GC26634@elte.hu>
References: <20080121230644.752379000@sgi.com> <20080121230647.038245000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121230647.038245000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> An early call to nr_free_zone_pages() calls numa_node_id() which
> needs to call early_cpu_to_node() since per_cpu(cpu_to_node_map)
> might not be setup yet.
> 
> I also had to export x86_cpu_to_node_map_early_ptr because of some
> calls from the network code to numa_node_id():
> 
> 	net/ipv4/netfilter/arp_tables.c:
> 	net/ipv4/netfilter/ip_tables.c:
> 	net/ipv4/netfilter/ip_tables.c:
> 
> Applies to both:
> 	
> 	2.6.24-rc8-mm1
> 	2.6.24-rc8-mm1 + latest (08/01/21) git-x86 patch

thanks, applied.

	Ingo
