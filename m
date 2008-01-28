Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbYA2Adq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbYA2Adq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYA2AdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:33:22 -0500
Received: from zrnetservice.com ([209.133.52.163]:50314 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756558AbYA2AdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:33:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] x86: cleanups from pmd lifetime series
Message-Id: <patchbomb.1201564120@localhost>
Date: Mon, 28 Jan 2008 15:48:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a followup set from that last batch of patches:
 1. fix up the pgd_ctor merge, so that non-PAE will end up getting
    kernel mappings
 2. revert "optimise-pud_clear-cr3-reload"
 3. only do a cr3 reload if pud_clear is being used on the active pagetable
 4. update documentation about PAE tlb flushing.

The third of these makes pud_clear more robust, since it doesn't rely
on it being followed by the right kind of TLB flush.  In practice it
shouldn't make any performance difference, since the only performance
critical paths pud_clear is used on are exit and execve, and they both
operate on some other pagetable at the time the old pagetable is being
pulled down.

It will generate TLB flushes in the case of a usermode process
munmapping a 1+G chunk of its address space, or something to do with
unsharing a hugetlbfs mapping.  I don't think either of these are
performance critical.

Thanks,
	J


