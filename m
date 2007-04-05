Return-Path: <linux-kernel-owner+w=401wt.eu-S1767254AbXDEToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767254AbXDEToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767259AbXDEToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:44:46 -0400
Received: from gw.goop.org ([64.81.55.164]:58616 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767254AbXDETop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:44:45 -0400
Message-ID: <4615518A.4070003@goop.org>
Date: Thu, 05 Apr 2007 12:44:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: What protects cpu_tlbstate?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What protects the cpu_tlbstate?  I see in i386/kernel/smp.c that its
always used in a non-preemptable area, but what prevents races with
interrupts?  For example, what prevents leave_mm() called via the
flush_tlb_all IPI from racing with, say, enter_lazy_tlb?  Couldn't a
race leave cpu_tlbstate in an inconsistent state?

Or does it simply not matter?  But if that were true, it seems to me
that there should be at least some barriers or something to make sure
the final state is consistent.

Thanks,
    J
