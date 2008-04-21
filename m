Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYDURmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYDURmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYDURmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:42:44 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:48553 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbYDURmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:42:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFAD9vDEhMROPA/2dsb2JhbACBUalE
Date: Mon, 21 Apr 2008 13:42:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421174239.GA14718@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com> <20080421154756.GA2424@Krystal> <20080421172327.GA32278@elf.ucw.cz> <480CCEB0.8040401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480CCEB0.8040401@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:40:31 up 52 days, 13:51,  4 users,  load average: 0.34, 0.48,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Pavel Machek wrote:
>>> There is also the page fault case. I think putting this test in
>>> ret_from_exception would be both safe (it is executed for any
>>> exception return) and fast (exceptions are rare).
>> Eh? I thought that page fault is one of the hottest paths in kernel
>> (along with syscall and packet receive/send)...
>> 								Pavel
>

On x86_64, we can pinpoint only the page faults returning to the kernel,
which are rare and only caused by vmalloc accesses. Ideally we could do
the same on x86_32.

> Yeah, and the concept of handling page faults inside an NMI handler is pure 
> fantasy.
>
> 	-hpa
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
