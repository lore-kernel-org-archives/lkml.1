Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbXKMTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbXKMTqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbXKMTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:45:54 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:61752 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758140AbXKMTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:45:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJ6NOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 14:45:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Message-ID: <20071113194550.GA4400@Krystal>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4739FCA0.4040702@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:42:20 up 10 days, 47 min,  7 users,  load average: 0.95, 1.26,
	1.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>>> - Use "=g" constraint for char immediate value inline assembly.
>>>
>>> "=g" is the same as "=rmi" which is inherently bogus.  In your actual 
>>> code you use "=r", the correct constraint is "=q".
>> q
>>     Any register accessible as rl. In 32-bit mode, a, b, c, and d; in 
>> 64-bit mode, any integer register. I am worried that "=q" might exclude 
>> the si and di registers in 32-bit mode.
>> What exactly is wrong with "=r" ?
>
> For "char" (8-bit) values, sp/bp/si/di are illegal in 32-bit mode.
>
> Hence "=q".
>

Ah! yep, I see, so we say:

1 byte : "=q"
2 bytes : "=r"
4 bytes : "=r"
8 bytes : "=r"

? (si and di appear to be legal for 2 and 4 bytes in 32-bit mode)




> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
