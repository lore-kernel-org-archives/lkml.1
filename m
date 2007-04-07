Return-Path: <linux-kernel-owner+w=401wt.eu-S965984AbXDGWTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984AbXDGWTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXDGWTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:19:07 -0400
Received: from ns.suse.de ([195.135.220.2]:38341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965977AbXDGWTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:19:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/4] x86_64: (SPARSE_VIRTUAL doubles sparsemem speed)
Date: Sun, 8 Apr 2007 00:18:44 +0200
User-Agent: KMail/1.9.6
Cc: Andy Whitcroft <apw@shadowen.org>, Martin Bligh <mbligh@google.com>,
       Dave Hansen <hansendc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0704051119400.9800@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0704071455060.31468@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704071455060.31468@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704080018.45084.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007 00:06:13 Christoph Lameter wrote:

> Results:
> 
> x86_64 boot with virtual memmap
> 
> Format:               #events totaltime (min/avg/max)
> 
> kfree_virt_to_page       598430 5.6ms(3ns/9ns/322ns)
> 
> x86_64 boot regular sparsemem
> 
> kfree_virt_to_page       596360 10.5ms(4ns/18ns/28.7us)
> 
> 
> On average sparsemem virtual takes half the time than of sparsemem.

Nice.  But on what workloads? 

Anyways it looks promising. I hope we can just
replace old style sparsemem support with this for x86-64.

> Time is measured using the cycle counter (TSC on IA32, ITC on IA64) which has
> a very low latency.

Sorry that triggered my usual RDTSC rant...

Not on NetBurst (hundred of cycles) And on the others (C2,K8) it is a bit dangerous 
to measure short code blocks because RDTSC is not guaranteed ordered with the surrounding 
instructions.

-Andi
 
