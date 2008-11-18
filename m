Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYKRR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYKRR2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYKRR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:28:15 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:29362 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYKRR2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:28:14 -0500
Message-Id: <4923096A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Nov 2008 17:28:58 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
References: <4921428A.76E4.0078.0@novell.com>
 <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com>
 <4921BA8E.60806@goop.org> <492284CE.76E4.0078.0@novell.com>
 <4922F4EC.6050408@goop.org>
In-Reply-To: <4922F4EC.6050408@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 18.11.08 18:01 >>>
>Yes, it disables interrupts while its actually issuing the multicall.  I 
>don't think that matters much, since the multicall itself can't be 
>preempted (can it?) and the rest of the code is very short.  Originally 
>it disabled interrupts for the entire lazy section, which is obviously 
>worse.

If an interrupt (event) comes in, a multicall could of course be 'preempted',
in order to service the event. But of course that works only if event
delivery isn't disabled.

>> There's no reason to do any flush at all if you suppress batching temporarily.
>> And it only needs (would need) explicit suppressing here because you can't
>> easily recognize being in the context of a page fault handler from the
>> batching functions (other than recognizing being in the context of an
>> interrupt handler, which is what would allow removing the flush calls from
>> highmem_32.c).
>
>I'm not sure what your concern is here.  If batching is currently 
>enabled, then the flush will push out anything pending immediately.  If 
>batching is disabled, then the flush will be a noop and return immediately.

Latency, as before. The page fault should have to take longer than it really
needs, and the flushing of a pending batch clearly doesn't belong to the
page fault itself.

Jan

