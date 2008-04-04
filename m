Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYDDUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYDDUj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYDDUjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:39:19 -0400
Received: from gw.goop.org ([64.81.55.164]:38979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYDDUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:39:18 -0400
Message-ID: <47F691BB.3080302@goop.org>
Date: Fri, 04 Apr 2008 13:38:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
References: <785fe0877fea0f488bc5.1207267545@localhost>  <1207270272.943.27.camel@nimitz.home.sr71.net> <47F5809A.7040307@goop.org>  <1207273978.943.82.camel@nimitz.home.sr71.net> <47F5BD6C.30100@goop.org> <1207318946.943.107.camel@nimitz.home.sr71.net> <47F6719E.9010807@goop.org> <Pine.LNX.4.64.0804041226080.3936@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0804041226080.3936@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Note that you could use 4k page size chunks for the memmap if its 
> virtualized (CONFIG_SPARSEMEM_VMEMMAP). Instead of a single PMD 
> pointing to a 2MB block you would have the PMD point to a block of
> ptes that would in turn point to the discontiguous series of 4k pages.
>
> The memory is virtually contiguous so all the logic stays the same. What 
> would be needed is some enhancements to the way the memmap is populated.

In Xen I think that would be accommodated by the existing 
pseudo-physical to machine mapping.  We don't support PSE anyway, so all 
the pages would be individual 4k pages; the fact that they're 
machine-discontigious is hidden because of the pseudo-phys to machine 
mapping when ptes are constructed.

    J
