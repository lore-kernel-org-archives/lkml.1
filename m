Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbXDBPhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbXDBPhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXDBPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:37:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45953 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbXDBPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:37:34 -0400
Date: Mon, 2 Apr 2007 08:37:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704011246.52238.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>
 <200704011246.52238.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Andi Kleen wrote:

> Hmm, this means there is at least 2MB worth of struct page on every node?
> Or do you have overlaps with other memory (I think you have)
> In that case you have to handle the overlap in change_page_attr()

Correct. 2MB worth of struct page is 128 mb of memory. Are there nodes 
with smaller amounts of memory? Note also that the default sparsemem
section size is (include/asm-x86_64/sparsemem.h)

#define SECTION_SIZE_BITS       27 /* matt - 128 is convenient right now */

128MB ....

So you currently cannot have smaller sections of memory anyways.

> Also your "generic" vmemmap code doesn't look very generic, but
> rather x86 specific. I didn't think huge pages could be easily
> set up this way in many other architectures.  

We do this pmd special casing in other parts of the core VM. I have also a 
patch for IA64 that workks with this.

> Do you have any benchmarks numbers to prove it? There seem to be a few
> benchmarks where the discontig virt_to_page is a problem
> (although I know ways to make it more efficient), and sparsemem
> is normally slower. Still some numbers would be good.

You want a benchmark to prove that the removal of memory references and 
code improves performance?

