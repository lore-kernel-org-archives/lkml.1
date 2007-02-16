Return-Path: <linux-kernel-owner+w=401wt.eu-S1945931AbXBPKtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945931AbXBPKtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945945AbXBPKtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:49:13 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:18805 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945931AbXBPKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:49:12 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 10:49:10 +0000
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disable unsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Dan Hecht <dhecht@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       <xen-devel@lists.xensource.com>, Ian Pratt <ian.pratt@xensource.com>,
       <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Message-ID: <C1FB3CA6.98EC%keir@xensource.com>
Thread-Topic: [patch 14/21] Xen-paravirt: Add XEN config options and
 disable unsupported config options.
Thread-Index: AcdRuBayVUAG+r2rEduvqQAX8io7RQ==
In-Reply-To: <45D56D5A.3000300@vmware.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 08:37, "Dan Hecht" <dhecht@vmware.com> wrote:

> Hmm?  I thought the periodic timer and one-shot timer both generate the
> same VIRQ.  So, how can you mask one without masking the other?
> 
> The tickless idle works since the block hypercall disables the periodic
> timer.  But for dynticks (aka NO_HZ), you'll need to mask the periodic
> timer (even for a running vcpu), while keeping the one-shot timer
> unmasked.  I don't think Xen provides an interface to do that.

There's no interface for this right now, but we can easily add one in a
backward compatible way. This also will not prevent a dyntick kernel from
running on an older Xen -- the guest will then receive to many timer
interrupts, but that should only be a performance concern fixable by
upgrading the hypervisor component of the system.

 -- Keir

