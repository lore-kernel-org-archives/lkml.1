Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYBIQkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYBIQkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYBIQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:40:06 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:47702 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYBIQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:40:04 -0500
Message-ID: <47ADD762.1010206@web.de>
Date: Sat, 09 Feb 2008 17:40:02 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][7/8] kgdb: exclusive use kgdb8250 uart I/O driver
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com> <1202564114-18587-6-git-send-email-jason.wessel@windriver.com> <1202564114-18587-7-git-send-email-jason.wessel@windriver.com> <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX18rPhya2ddMF6Lh+B+b6oaV/3coIqsk58sPcIDo
	CL9E2u/bwVSVrE2jCJlCXmrYPbtCDaUJ5BSga4IDjH0A85wvt6
	ImSJclVmc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jason.wessel@windriver.com wrote:
> @@ -2175,9 +2187,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
>  
>  		/*
>  		 * Power down all ports by default, except the
> -		 * console if we have one.
> +		 * console (real or kgdb) if we have one.
>  		 */
> -		if (!uart_console(port))
> +		if (!uart_console(port) && !uart_kgdb(port))
>  			uart_change_pm(state, 3);

Jason, thinking about this hunk again, it appears broken to me. If we
needed it for 8250_kgdb, we would also need it without
CONFIG_KGDB_CONSOLE. However, powering on the UART with a special dance
after we took over with 8250_kgdb is a job that has to be done _there_,
not by this hook here. So let's drop the whole serial_core.c hunk from
this patch.

Jan
