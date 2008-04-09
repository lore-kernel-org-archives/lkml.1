Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYDIWsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYDIWsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYDIWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:48:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYDIWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:48:18 -0400
Message-ID: <47FD4424.20907@zytor.com>
Date: Wed, 09 Apr 2008 15:33:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org
Subject: Re: [patch 13/17] Immediate Values - x86 Optimization (updated)
References: <20080409150829.855195878@polymtl.ca> <20080409152051.117322728@polymtl.ca> <47FD0497.10303@zytor.com> <20080409202106.GA1675@Krystal>
In-Reply-To: <20080409202106.GA1675@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Hrm, since even the nmi-safe version supports REX-prefixed instructions,
> there is no need for an =q constraint on single-byte immediate values
> anymore. (thanks to your "discard" section used in the nmi-safe version)
> 

WRONG!

Using =r for single-byte values is incorrect for 32-bit code -- that 
would permit %spl, %bpl, %sil, %dil which are illegal in 32-bit mode. 
That is not the incorrect bit, it's the description that is confused.

	-hpa
