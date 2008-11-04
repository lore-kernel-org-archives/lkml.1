Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYKDWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYKDWgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYKDWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:36:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:47600 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbYKDWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:36:04 -0500
Message-ID: <4910CDF6.1040901@kernel.org>
Date: Tue, 04 Nov 2008 14:34:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
References: <4910C845.4060909@kernel.org> <1225837748.3074.54.camel@achroite>
In-Reply-To: <1225837748.3074.54.camel@achroite>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Tue, 2008-11-04 at 14:10 -0800, Yinghai Lu wrote:
>> Impact: so NR_IRQS is bigger enough for system with lots of apic/pins
>>
>> Now: if IO_APIC is there, will have big NR_IRQS
>>
>> otherwise still use 224
> [...]
> 
> I have no idea whether this is useful, but it doesn't solve the general
> problem that probe_nr_irqs() can return a value > NR_IRQS.  So far as I
> can see it can return up to 2 * 24 * MAX_IO_APICS which may be greater
> than NR_VECTORS + (32 * max(MAX_IO_APICS, NR_CPUS)).

your patch is still needed...
also please add one WARN_ON when nr > NR_IRQS.

YH
