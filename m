Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZBVRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZBVRI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBVRIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:08:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54850 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZBVRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:08:19 -0500
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: Andi Kleen <andi@firstfloor.org>
References: <20090129.155852.161923905.davem@davemloft.net>
Date: Sun, 22 Feb 2009 18:06:45 +0100
In-Reply-To: <20090129.155852.161923905.davem@davemloft.net> (David Miller's message of "Thu, 29 Jan 2009 15:58:52 -0800 (PST)")
Message-ID: <873ae6wgd6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

Really old mail, but I was very behind. I didn't see an 
correct answer, so let's answer it.

> While working on an NMI watchdog implementation on sparc64
> I noticed what seems to be a peculiar behavior of the NMI
> timer int oprofile support on x86.
>
> When the NMI watchdog tests itself at boot timer we start
> with nmi_hz equal to HZ.
>
> After the NMI watchdog self-test passes, nmi_hz is reduced
> down to '1'.
>
> The NMI timer int oprofile support simply uses DIE_NMI notifiers for
> it's implementation.  But I don't see anything in the code of
> arch/x86/oprofile/nmi_timer_int.c nor the NMI watchdog infrastructure
> which will re-adjust nmi_hz back to HZ or something similar.
>
> Am I missing something?

oprofile generates its own NMIs, it does not rely on 
the ones from the nmi watchdog.

In timer mode it does not use nmis or die notifiers, but relies on the 
regular non nmi timer interrupt.

Does that answer your question?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
