Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZA3VyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZA3VyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZA3VyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:54:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48017
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbZA3VyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:54:11 -0500
Date: Fri, 30 Jan 2009 13:54:09 -0800 (PST)
Message-Id: <20090130.135409.180077287.davem@davemloft.net>
To: mingo@elte.hu
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090130150125.GF31009@elte.hu>
References: <20090129.155852.161923905.davem@davemloft.net>
	<20090130150125.GF31009@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 30 Jan 2009 16:01:25 +0100

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > While working on an NMI watchdog implementation on sparc64 I noticed 
> > what seems to be a peculiar behavior of the NMI timer int oprofile 
> > support on x86.
> > 
> > When the NMI watchdog tests itself at boot timer we start with nmi_hz 
> > equal to HZ.
> > 
> > After the NMI watchdog self-test passes, nmi_hz is reduced down to '1'.
> > 
> > The NMI timer int oprofile support simply uses DIE_NMI notifiers for 
> > it's implementation.  But I don't see anything in the code of 
> > arch/x86/oprofile/nmi_timer_int.c nor the NMI watchdog infrastructure 
> > which will re-adjust nmi_hz back to HZ or something similar.
> > 
> > Am I missing something?
> 
> Reducing it to 1 HZ was kind of a performance hack: running NMIs at HZ 
> needlessly interrupts the CPU HZ times a second. It's more than enough to 
> have 1 nmi-watchdog tick per second to notice deadlocks that take longer 
> than 5 seconds.

For the NMI watchdog's purposes I understand the intent, and this
is perfectly fine.

The problem is that it stays at '1' when oprofile starts using the NMI
watchdog, and we certainly want more than one oprofile tick per second
:-)
