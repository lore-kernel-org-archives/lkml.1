Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbZEMRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbZEMRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbZEMRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:36:24 -0400
Received: from gw.goop.org ([64.81.55.164]:46968 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZEMRgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:36:23 -0400
Message-ID: <4A0B0516.8010104@goop.org>
Date: Wed, 13 May 2009 10:36:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH FIXED] x86: use flush_tlb_others to implement	flush_tlb_all
References: <4A09E5FE.2080507@goop.org> <4A0A0D7C.8050206@zytor.com>	 <4A0A154C.9080000@goop.org> <1242204775.24976.7.camel@zakaz.uk.xensource.com>
In-Reply-To: <1242204775.24976.7.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> get_cpu() returns smp_processor_id() so wouldn't this be more normally
> written as:
> 	/* flush_tlb_others expects preempt to be disabled */
> 	unsigned long cpu = get_cpu();
> 	[....]
> 	if ([....] == TLBSTATE_LAZY)
> 		leave_mm(cpu)
> 	put_cpu();
>   

Quite so.  In theory gcc should be able to CSE smp_processor_id(), but 
the intent of get_cpu() is that you use its return value...

    J
