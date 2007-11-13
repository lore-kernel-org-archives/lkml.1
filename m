Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbXKMTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbXKMTY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXKMTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:24:49 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:48197 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbXKMTYs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:24:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAPyIOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 14:24:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Message-ID: <20071113192445.GA1463@Krystal>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4739F609.50501@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:18:41 up 10 days, 24 min,  6 users,  load average: 4.13, 1.86,
	0.97
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
> - Use "=g" constraint for char immediate value inline assembly.
>
> "=g" is the same as "=rmi" which is inherently bogus.  In your actual code 
> you use "=r", the correct constraint is "=q".
>

Hi Peter,

Yup, =g wasn't what I was looking for at all, the header comment is
bogus.

From
http://gcc.gnu.org/onlinedocs/gcc/Simple-Constraints.html#Simple-Constraints

`r'
    A register operand is allowed provided that it is in a general register.

From
http://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html#Machine-Constraints
Intel 386   config/i386/constraints.md

q
    Any register accessible as rl. In 32-bit mode, a, b, c, and d; in 64-bit mode, any integer register. 


I am worried that "=q" might exclude the si and di registers in 32-bit mode.

What exactly is wrong with "=r" ?


> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
