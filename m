Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbXLSTtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbXLSTtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXLSTs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:48:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXLSTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:48:56 -0500
Message-ID: <4769757E.306@zytor.com>
Date: Wed, 19 Dec 2007 11:48:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu> <476972A0.3050105@zytor.com> <20071219194032.GA8849@elte.hu>
In-Reply-To: <20071219194032.GA8849@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i dont think it's required for C3 to even turn off any portion of the 
> CPU - if an interrupt arrives after the C3 sequence is initiated but 
> just before dirty cachelines have been flushed then the CPU can just 
> return without touching anything (such as the TLB) - right? So i dont 
> think there's any implicit guarantee of TLB flushing (nor should there 
> be), but in practice, a good C3 sequence would (statistically) turn off 
> large portions of the CPU and hence the TLB as well.
> 

I think C3 guarantees that the cache contents stay intact, and thus it 
might make sense in some technology to preserve the TLB as well (being a 
kind of cache.)

Otherwise, what you say here of course is absolutely correct.

	-hpa
