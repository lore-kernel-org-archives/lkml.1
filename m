Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYH3Wml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYH3Wml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYH3WmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:42:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbYH3WmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:42:16 -0400
Date: Sat, 30 Aug 2008 15:41:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>  <200808300030.32905.rjw@sisk.pl>  <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
  <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>  <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>  <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>  <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Yinghai Lu wrote:
> 
> in old kernel, after BAR3 request_filed, pci_assigned_unassigned
> should get update resource for that... but it could find that big
> space for it.

Exactly. So what happens is that it doesn't actually re-allocate it at 
all. Not that it is necessarily even possible - it's quite possible that 
that field is effectively locked some way and is read-only. Without 
knowing the chipset details, we can only guess.

		Linus
