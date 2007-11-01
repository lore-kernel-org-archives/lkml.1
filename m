Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXKBBCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXKBBCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXKBBCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:02:09 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56171 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbXKBBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:02:08 -0400
Subject: Re: [Lguest] [PATCH 3/16] read/write_crX, clts and wbinvd for
	64-bit paravirt
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, mingo@elte.hu, ak@suse.de,
       linux-kernel@vger.kernel.org, anthony@codemonkey.ws, tglx@linutronix.de,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       virtualization@lists.linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <472A0FBF.6040907@goop.org>
References: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
	 <472A0FBF.6040907@goop.org>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 09:55:13 -0700
Message-Id: <1193936113.29447.56.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 10:41 -0700, Jeremy Fitzhardinge wrote:
> Keir Fraser wrote:
> > volatile prevents the asm from being 'moved significantly', according to the
> > gcc manual. I take that to mean that reordering is not allowed.
> >   

I understood it as reordering was permitted, but no re-ordering across
another volatile load, store, or asm was permitted.  And of course, as
long as input and output constraints are written properly, the
re-ordering should not be vulnerable to pathological movement causing
the code to malfunction.

It seems that CPU state side effects which can't be expressed in C need
special care - FPU is certainly one example.

Also, memory clobber on a volatile asm should stop invalid movement
across TLB flushes and other problems areas.  Even memory fences should
have memory clobber in order to stop movement of loads and stores across
the fence by the compiler.

Zach

