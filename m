Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbYHFBpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbYHFBpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYHFBgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:36:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYHFBgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:36:07 -0400
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26 2/25] mdb: Merkey's Kernel Debugger
From: Andi Kleen <andi@firstfloor.org>
References: <51549.166.70.238.45.1217815820.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <51549.166.70.238.45.1217815820.squirrel@webmail.wolfmountaingroup.com> (jmerkey@wolfmountaingroup.com's message of "Sun, 3 Aug 2008 20:10:20 -0600 (MDT)")
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
Date: Wed, 06 Aug 2008 03:35:59 +0200
Message-ID: <878wvb6i2o.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com writes:
> regs->ip)
> -#ifndef CONFIG_KPROBES
> +#if !defined(CONFIG_KPROBES) && !defined(CONFIG_MDB)
>  DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
>  #endif
>  DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
> @@ -733,6 +747,9 @@
>  {
>  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
> NOTIFY_STOP)
>  		return;
> +#ifdef	CONFIG_MDB
> +        mdb(NMI_EXCEPTION, reason, regs); // nmi is code 2
> +#endif

This should be all using die notifiers (register_die etc.) like the 
other kernel debuggers, not own hooks. As you can see there is already
a notify_die call around basically all the places you put in a mdb()
call, and you can just hook in there. If your other interfaces to the core 
kernel are clean enough this would even allow to use your debugger as a module.

-Andi
