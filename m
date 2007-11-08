Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbXKHXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbXKHXMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbXKHXMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:12:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:43487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXKHXMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:12:09 -0500
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: Some interesting observations when trying to optimize vmstat handling
Date: Fri, 9 Nov 2007 00:07:42 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711090007.43424.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> There is an interrupt enable overhead of 48 cycles that would be good to
> be able to eliminate (Kernel code usually moves counter increments into
> a neighboring interrupt disable section so that __ function can be used).

Replace the push flags ; popf  with test $IFMASK,flags ; jz 1f; sti ; 1:
That will likely make it much faster (but also bigger) 

The only problem is that there might be some code who relies on 
restore_flags() restoring other flags that IF, but at least for interrupts
and local_irq_save/restore it should be fine to change.

-Andi

