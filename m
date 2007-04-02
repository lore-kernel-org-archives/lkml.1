Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXDBPoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXDBPoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932738AbXDBPoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:44:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46702 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932508AbXDBPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:44:27 -0400
Date: Mon, 2 Apr 2007 08:44:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704011246.52238.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704020840370.30394@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>
 <200704011246.52238.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Andi Kleen wrote:

> And when you reserve virtual space somewhere you should 
> update Documentation/x86_64/mm.txt. Also you didn't adjust 
> the end of the vmalloc area so in theory vmalloc could run
> into your vmemmap.

Ok. will add to the doc in the next release.

No need to adjust the end of the vmalloc area because
the vmemmap starts at the end of it:

include/asm-x86_64/pgtable.h:

#define VMALLOC_START    0xffffc20000000000UL
#define VMALLOC_END      0xffffe1ffffffffffUL

Index: linux-2.6.21-rc5-mm2/include/asm-x86_64/page.h

#define vmemmap ((struct page *)0xffffe20000000000UL)

According to Documentation/x86_64/mm.txt this is an unused hole:

ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
... unused hole ...
ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
... unused hole ...

