Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYDUPVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYDUPVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYDUPVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:21:23 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:55302 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYDUPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:21:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFAA1ODEhMROPA/2dsb2JhbACBUakB
Date: Mon, 21 Apr 2008 11:21:20 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421152120.GA7159@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480CADD3.3010209@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:18:16 up 52 days, 11:29,  5 users,  load average: 0.42, 0.33,
	0.31
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

Because I would have to do a more invasive code modification, since they
currently share their return path with normal interrupts. I agree that
the next step is to tune the patchset to only target traps and
exceptions which may happen on top of an NMI. I'll change it in my next
patchset version.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
