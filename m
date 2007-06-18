Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXFRJFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXFRJFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbXFRJFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:05:07 -0400
Received: from aun.it.uu.se ([130.238.12.36]:61696 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbXFRJFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:05:06 -0400
Date: Mon, 18 Jun 2007 10:57:29 +0200 (MEST)
Message-Id: <200706180857.l5I8vT6H000980@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: gshan@alcatel-lucent.com, linux-kernel@vger.kernel.org
Subject: Re: Questions on one PowerPC assembly instruction from hash_page
Cc: jinminc@alcatel-lucent.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 16:33:22 +0800, gshan <gshan@alcatel-lucent.com> wrote:
> I can't understand the following instructions from 
> arch/ppc/mm/hashtable.S::hash_page. If I got the right design, the 
> following instruction is to get the PMD (Page Middle Descritor) because 
> Linux for 32-bits PowerPC cut page table into 3 domains: root, PMD, PTE. 
> The top bits (22 to 31 bit) is the index for PMD, and the next 10 bits 
> (12 to 21 bit) is the index for PTE in the associative PMD. The 
> remaining 12 bits (0 to 11 bit) indicated the page size (4KB). However, 
> the following instruction polled [8-17] bits instead of [22-31] bits as 
> expected. Anybody could give me answer?
> 
> r4 is the address that caused the DSI
> r5 is the address of swapper_pg_dir if we are under kernel mode.
> 
> rlwimi r5,r4,12,20,29 /* insert top 10 bits of address */

POWER/PowerPC has an insanely broken bit numbering scheme, in
which the most significant bit has number 0 (or is it 1?),
and the least significant bit has number N-1 (or is it N?)
where N is number of bits in a word.

The fact that you refer to the top bits as 22-31 makes me
suspect that you haven't compensated for this quirk.

/Mikael
