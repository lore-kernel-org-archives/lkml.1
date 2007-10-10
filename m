Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXJJVzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXJJVzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbXJJVrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:47:00 -0400
Received: from gw.goop.org ([64.81.55.164]:35271 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651AbXJJVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:46:59 -0400
Message-ID: <470D4826.2060903@goop.org>
Date: Wed, 10 Oct 2007 14:46:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386:  remove dead code in pgtable_cache_init
References: <470D3846.1000209@goop.org> <Pine.LNX.4.64.0710101407560.32488@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710101407560.32488@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> I believe that virtualization support needed a full pgd.
>   

Yes, Xen requires it for PAE pgds, at least at the moment.  But native,
lguest, vmi and kvm don't.  I'd made it so that the memory overhead was
only paid in the Xen case.  Allocating a whole page all the time
certainly simplifies things, but at the cost of more overhead for everyone.

If we move away from using the page->private field to link the pgds
together, then I can probably remove Xen's need to allocate a whole page
for PAE pgds.

    J
