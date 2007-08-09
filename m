Return-Path: <linux-kernel-owner+w=401wt.eu-S939966AbXHIN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939966AbXHIN2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939203AbXHIN2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:28:42 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:36522
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939197AbXHIN2l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:28:41 -0400
Message-Id: <46BB32F6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 09 Aug 2007 14:29:58 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>, "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [4/12] x86_64: Disable CLFLUSH support
	again
References: <20070809241.425881000@suse.de>
 <20070809124131.B6E6114F3B@wotan.suse.de>
 <20070809131121.GL3311@rhun.haifa.ibm.com>
In-Reply-To: <20070809131121.GL3311@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Muli Ben-Yehuda <muli@il.ibm.com> 09.08.07 15:11 >>>
>On Thu, Aug 09, 2007 at 02:41:31PM +0200, Andi Kleen wrote:
>> 
>> It turns out CLFLUSH support is still not complete; we
>> flush the wrong pages.  Again disable it for the release.
>> Noticed by Jan Beulich.
>> 
>> Signed-off-by: Andi Kleen <ak@suse.de>
>
>Aside from the bug Jan pointed out with the patch, we're also using
>cflflush in other places (arch/i386/kernel/alternative.c and
>arch/x86_64/kernel/tce.c). Is the issue with clflush support specific
>to pageattr.c or should it be disabled every else too? what
>specifically is the issue?

The issue here is not with clflush by itself, but with what pages it is being
applied to. Here, it gets used on page table pages when flushing really is
needed on what one or more page table entries in that page table page
point(ed) to.

Jan

