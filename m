Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbYDUPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbYDUPsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYDUPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:47:59 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:51872 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYDUPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:47:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFANNTDEhMROPA/2dsb2JhbACBUakD
Date: Mon, 21 Apr 2008 11:47:56 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421154756.GA2424@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480CADD3.3010209@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:46:25 up 52 days, 11:57,  5 users,  load average: 0.07, 0.28,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Just to be clear : the added cost on normal interrupt return is to add a
>> supplementary test of the thread flags already loaded in registers and
>> a conditional branch. This is used to detect if we are nested over an
>> NMI handler. I doubt anyone ever notice an impact caused by this added
>> test/branch.
>
> Why the **** would you do this except in the handful of places where you 
> actually *could* be nested over an NMI handler (basically #MC, #DB and 
> INT3)?
>
> 	-hpa
>

There is also the page fault case. I think putting this test in
ret_from_exception would be both safe (it is executed for any
exception return) and fast (exceptions are rare).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
