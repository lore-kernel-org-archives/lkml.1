Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBWEMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBWEMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZBWEMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:12:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZBWEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:12:11 -0500
Date: Sun, 22 Feb 2009 20:11:52 -0800 (PST)
Message-Id: <20090222.201152.169082487.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <873ae6wgd6.fsf@basil.nowhere.org>
References: <20090129.155852.161923905.davem@davemloft.net>
	<873ae6wgd6.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sun, 22 Feb 2009 18:06:45 +0100

> David Miller <davem@davemloft.net> writes:
> 
> Really old mail, but I was very behind. I didn't see an 
> correct answer, so let's answer it.
> 
> > While working on an NMI watchdog implementation on sparc64
> > I noticed what seems to be a peculiar behavior of the NMI
> > timer int oprofile support on x86.
> >
> > When the NMI watchdog tests itself at boot timer we start
> > with nmi_hz equal to HZ.
> >
> > After the NMI watchdog self-test passes, nmi_hz is reduced
> > down to '1'.
> >
> > The NMI timer int oprofile support simply uses DIE_NMI notifiers for
> > it's implementation.  But I don't see anything in the code of
> > arch/x86/oprofile/nmi_timer_int.c nor the NMI watchdog infrastructure
> > which will re-adjust nmi_hz back to HZ or something similar.
> >
> > Am I missing something?
> 
> oprofile generates its own NMIs, it does not rely on 
> the ones from the nmi watchdog.

The code in nmi_timer_int.c doesn't.

> In timer mode it does not use nmis or die notifiers, but relies on the 
> regular non nmi timer interrupt.

Again, the code in nmi_timer_int.c doesn't.

It uses the NMI watchdog timer interrupts, it catches DIE_NMI
events.

> Does that answer your question?

Not really.
