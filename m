Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbXHJMFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbXHJMFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbXHJMEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:04:36 -0400
Received: from ozlabs.org ([203.10.76.45]:53577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXHJMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:04:34 -0400
Subject: Re: [Lguest] [PATCH] lguest: Fix Malicious Guest GDT Host Crash
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, lguest <lguest@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46BB3692.5010003@vmware.com>
References: <1186657033.17752.58.camel@localhost.localdomain>
	 <46BB3692.5010003@vmware.com>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 22:04:00 +1000
Message-Id: <1186747440.23993.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 08:45 -0700, Zachary Amsden wrote:
> Rusty Russell wrote:
> > We kill the Guest if it causes a fault in the Switcher: it's the
> > Guest's responsibility to make sure it's not using segments when it
> > changes them.
> 
> Linux doesn't obey that rule.  It changes descriptors behind FS/GS all 
> over the place.  Well, not all over the place, only when updating LDT 
> entries

Hi Zach,

	I think it's OK.  To clarify, it's only fatal when the guest changes
them in a way that will fault if they're reloaded: not any change.
Lguest doesn't support LDT, so that's not a problem.

> , TLS entries, and during context switch.

These two go through load_TLS -> lguest_load_tls which is patched by
this same change to load 0 into gs before doing the hypercall.  The
other segment registers are set by the kernel, and so we know they don't
refer to changing entries.

Is there anything I've missed?
Rusty.

