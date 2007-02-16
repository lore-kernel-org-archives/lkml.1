Return-Path: <linux-kernel-owner+w=401wt.eu-S964890AbXBPRKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890AbXBPRKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbXBPRKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:10:33 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:37297 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbXBPRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:10:32 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 17:10:29 +0000
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>
CC: Zachary Amsden <zach@vmware.com>, <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>, <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Message-ID: <C1FB9605.9988%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and
 free vmalloc areas
Thread-Index: AcdR7VulmlTzEL3gEduvqQAX8io7RQ==
In-Reply-To: <45D5DFF3.6040005@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On 16/2/07 16:46, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Yes, that would work.  Unfortunately that's i386 arch-specific, whereas
> the rest of this code is generic.  I guess I could just move it all to
> arch/i386/mm.

This whole thing isn't an issue on ia64 (they no-op lock_vm_area) and
powerpc doesn't use any of the Xen driver code at this time.
vmalloc_sync_all is supported by both i386 and x86_64, so we can make the
call conditional on CONFIG_X86 so that ia64 will continue to build. This is
what I've done in xen-unstable.

 -- Keir

