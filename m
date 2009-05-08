Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZEHE7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZEHE7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZEHE7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:59:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZEHE7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:59:30 -0400
Message-ID: <4A03BC1A.9060605@zytor.com>
Date: Thu, 07 May 2009 21:59:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com>
In-Reply-To: <4A0199B8.76EA.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Impact: bug fix
> 
> Blindly putting the gap close after max_pfn is in conflict with that
> same memory range potentially being used by hotplugged memory.
> 
> Also, make the function static to ensure there are no other users that
> could depend on the previous behavior regarding the way start_addr gets
> specified.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 

So blindly locate it somewhere else?  How is that inherently better?
Wouldn't a machine with hotplug memory (which doesn't bother advertising
that fact so we can reserve the address space) be just as likely to use
a sparse memory space, since one can hardly expect the hardware to pack
the space (packing in hardware is why PCs generally have a
mostly-contiguous RAM space) when the memory is hotplugged?

I think I'm missing something fundamental...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

