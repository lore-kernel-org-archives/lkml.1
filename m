Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXFDVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXFDVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXFDVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:47:11 -0400
Received: from ns.suse.de ([195.135.220.2]:34068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXFDVrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:47:10 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: use iret directly where possible
Date: Mon, 4 Jun 2007 23:46:54 +0200
User-Agent: KMail/1.9.1
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46646662.9020707@goop.org> <200706042305.05340.ak@suse.de> <4664841A.8040802@goop.org>
In-Reply-To: <4664841A.8040802@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706042346.55049.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 23:28, Jeremy Fitzhardinge wrote:

> The cli/sti instructions don't control the event mask, so they're
> effectively expensive no-ops (they trap into the hypervisor, are
> emulated as no-ops). But if you mean cli as a general term for
> "events/interrupts masked", then they can't remain masked when you
> return to usermode.   iret normally sets the current eflags IF state
> from the on-stack IF, but that's irrelevent to Xen; we need to extract
> eflags.IF from the on-stack eflags, and put that into the vcpu's event
> mask.  That's inherently non-atomic with respect to iret.

Ah I assumed the hypervisor would just check IF in ring 1 too.
It would certainly make this easier, but then the additional trap
of setting it would be also somewhat expensive agreed.

I must say I still hate the patch; it has all the signs of something that
will be very nasty to maintain later.

-Andi
