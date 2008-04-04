Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYDDT3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYDDT3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYDDT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:29:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35745 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751116AbYDDT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:29:00 -0400
Date: Fri, 4 Apr 2008 12:28:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
In-Reply-To: <47F6719E.9010807@goop.org>
Message-ID: <Pine.LNX.4.64.0804041226080.3936@schroedinger.engr.sgi.com>
References: <785fe0877fea0f488bc5.1207267545@localhost> 
 <1207270272.943.27.camel@nimitz.home.sr71.net> <47F5809A.7040307@goop.org>
  <1207273978.943.82.camel@nimitz.home.sr71.net> <47F5BD6C.30100@goop.org>
 <1207318946.943.107.camel@nimitz.home.sr71.net> <47F6719E.9010807@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Jeremy Fitzhardinge wrote:

> > Say that you have a very fragmented lowmem-only machine and you want to
> > add a section of new mem_map[].  That's 512MB/PAGE_SIZE*sizeof(struct
> > page), which is between 4 and 8MB.  So, you need 8MB of contiguous pages
> > for that mem_map[].  The way we designed it, you could always have that

Note that you could use 4k page size chunks for the memmap if its 
virtualized (CONFIG_SPARSEMEM_VMEMMAP). Instead of a single PMD 
pointing to a 2MB block you would have the PMD point to a block of
ptes that would in turn point to the discontiguous series of 4k pages.

The memory is virtually contiguous so all the logic stays the same. What 
would be needed is some enhancements to the way the memmap is populated.


