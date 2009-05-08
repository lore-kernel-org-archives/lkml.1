Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZEHGjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZEHGjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZEHGjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:39:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46912 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZEHGje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:39:34 -0400
Message-Id: <4A03F016.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 08 May 2009 07:40:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com>
In-Reply-To: <4A03BC1A.9060605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 08.05.09 06:59 >>>
>Jan Beulich wrote:
>> Impact: bug fix
>> 
>> Blindly putting the gap close after max_pfn is in conflict with that
>> same memory range potentially being used by hotplugged memory.
>> 
>> Also, make the function static to ensure there are no other users that
>> could depend on the previous behavior regarding the way start_addr gets
>> specified.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
>
>So blindly locate it somewhere else?  How is that inherently better?
>Wouldn't a machine with hotplug memory (which doesn't bother advertising
>that fact so we can reserve the address space) be just as likely to use
>a sparse memory space, since one can hardly expect the hardware to pack
>the space (packing in hardware is why PCs generally have a
>mostly-contiguous RAM space) when the memory is hotplugged?

Why blindly? Aren't hotpluggable memory ranges supposed to be reserved
in the E820 map?

Jan

