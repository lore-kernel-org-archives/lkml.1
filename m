Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYDUPIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYDUPIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYDUPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:08:28 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:60938 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589AbYDUPI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:08:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFAOtKDEhMROPA/2dsb2JhbACBUah5
Date: Mon, 21 Apr 2008 11:08:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421150825.GA4070@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480CA337.3090709@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:06:11 up 52 days, 11:17,  6 users,  load average: 0.25, 0.30,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Pavel Machek wrote:
>> On Thu 2008-04-17 16:14:10, Mathieu Desnoyers wrote:
>>> (hopefully finally CCing LKML) :)
>>>
>>> Implements an alternative iret with popf and return so trap and exception
>>> handlers can return to the NMI handler without issuing iret. iret would 
>>> cause
>>> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 
>>> has to
>>> copy the return instruction pointer to the top of the previous stack, 
>>> issue a
>>> popf, loads the previous esp and issue a near return (ret).
>> sounds expensive. Does it slow down normal loads?
>
> It should *only* be used to return from NMI, #MC or INT3 (breakpoint), 
> which should never happen in normal operation, and even then only when 
> interrupting another NMI or #MC handler.
>
> 	-hpa
>

Just to be clear : the added cost on normal interrupt return is to add a
supplementary test of the thread flags already loaded in registers and
a conditional branch. This is used to detect if we are nested over an
NMI handler. I doubt anyone ever notice an impact caused by this added
test/branch.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
