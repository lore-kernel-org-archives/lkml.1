Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYDXTcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYDXTcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761436AbYDXTc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:32:29 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:61849 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380AbYDXTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:32:28 -0400
Message-ID: <4810E033.4090903@freescale.com>
Date: Thu, 24 Apr 2008 14:32:03 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Calling free_pages on part of the memory returned by get_free_pages?
References: <480D032E.20204@freescale.com> <87r6cvxdd4.fsf@basil.nowhere.org>
In-Reply-To: <87r6cvxdd4.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> It is ok, as long as you don't use compound pages (__GFP_COMP) and call
> split_page() to fix up the reference counts.

Thanks.  I've never even heard of compound pages, so that's not a problem.  I'll
look up split_page().

> Also you do this to save memory right? 

Yes, I expect to allocate a 5MB chunk of memory, which means I'll be wasting 3MB
of physically-contiguous memory on an embedded system.

> The large system hash code does it too

Ah, I see that in alloc_large_system_hash().  Thanks

> If it's reasonably common we should re-add alloc/get_pages_exact() helper to 
> make this pattern clear and easier to use.

I'd be in favor of that!  I was planning on doing something like that anyway.

-- 
Timur Tabi
Linux kernel developer at Freescale
