Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbXKANBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbXKANBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbXKANBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:01:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56043 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756159AbXKANBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:01:15 -0400
Date: Thu, 1 Nov 2007 06:01:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: dada1@cosmosbay.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071101.005727.218970168.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711010559300.27666@schroedinger.engr.sgi.com>
References: <20071101000211.970501947@sgi.com> <47297DA6.5070904@cosmosbay.com>
 <20071101.005727.218970168.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, David Miller wrote:

> IA64 seems to use it universally for every __get_cpu_var()
> access, so maybe it works out somehow :-)))

IA64 does not do that. It addds the local cpu offset

#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, 
__ia64_per_cpu_var(local_per_cpu_offset)))
#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, 
__ia64_per_cpu_var(local_per_cpu_offset)))


