Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbYDNSym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbYDNSym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYDNSyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:54:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:44803 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbYDNSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:54:30 -0400
Message-ID: <4803A85F.2080603@colorfullife.com>
Date: Mon, 14 Apr 2008 20:54:23 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net>	 <1207931235.7157.0.camel@twins>  <4802E93E.4090205@bull.net> <1208157359.7427.25.camel@twins> <480316D3.7070901@bull.net>
In-Reply-To: <480316D3.7070901@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
>
> Well, 1 interface changes, 1 is added and another one went away:
>
> 1) for the preload part (it becomes like the radix-tree preload part):
>
> int idr_pre_get(struct idr *, gfp_t);
> would become
> int idr_pre_get(gfp_t);
>
Btw, that's one point I didn't understand about the idr code:
Is it interrupt-safe? It uses spin_lock_irqsave and gfp_t, this implies 
that it could be called from all contexts.

But the prealloc made me a bit nervous: does it handle idr_pre_get(); 
interrupt with another idr_pre_get(), add, pre_get_end, interrupt ends, 
... correctly?

If it's only intended to be called from process context I would remove 
the _irqsave and perhaps add an assert(!in_interrupt())
--
    Manfred
