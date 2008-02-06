Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYBFEkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYBFEkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYBFEkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:40:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:64656 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYBFEkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:40:35 -0500
Message-ID: <47A93A35.3090001@windriver.com>
Date: Tue, 05 Feb 2008 22:40:21 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] KGDB: Major refactoring
References: <47A8F275.9090901@web.de>
In-Reply-To: <47A8F275.9090901@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2008 04:40:01.0824 (UTC) FILETIME=[5600A200:01C8687A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> As most changes are tightly coupled, this refactoring patch for
> KGDB_8250 as well as the core and the new KGDBOC driver comes as a
> single chunk. The changes are:
>  - Reorganized configuration: I/O drivers can be independently
>    configured as module or built-in
>  - Dynamic reconfiguration for KGDB_8250 (just like for KGDBOC)
>  - Reworked KGDB_8250 configuration string format
>  - attachwait removed, arming the debugger via assigning an I/O driver
>    implies "attachwait"
>  - Cleaned up I/O driver managment of the core
>  - Matured the various boot-up, configure, unconfigure code paths for
>    both I/O drivers
>  - IRQ vs. KGDB_CONSOLE-output SMP race fixed for KGDB_8250
>  - Reduced and cleaned up hooks into serial_core/8250
>  - Kconfig cleanups
>
> What we no longer have:
>  - Simple serial configuration for _early_ debugging, use the io/mem
>    format instead or wait until the debugger is able to resolve "ttySx"
>    during late-init
>
> To-do:
>  - KGDBOC does not yet cleanly interacts with the TTY subsystem to
>    attach to some console
>
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>   

Jan,

I pulled in all your changes and made some minor white space fixes. 

I started the 2.6.25 branch with all Ingo's changes, your changes and
several additional patches I received.

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=summary

Thanks,
Jason.
