Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYBISl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYBISl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYBISlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:41:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:57964 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYBISlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:41:49 -0500
Message-ID: <47ADF3E5.6060006@windriver.com>
Date: Sat, 09 Feb 2008 12:41:41 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][7/8] kgdb: exclusive use kgdb8250 uart I/O driver
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com> <1202564114-18587-6-git-send-email-jason.wessel@windriver.com> <1202564114-18587-7-git-send-email-jason.wessel@windriver.com> <1202564114-18587-8-git-send-email-jason.wessel@windriver.com> <47ADD762.1010206@web.de>
In-Reply-To: <47ADD762.1010206@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2008 18:41:18.0979 (UTC) FILETIME=[5BF87D30:01C86B4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> jason.wessel@windriver.com wrote:
>   
>> @@ -2175,9 +2187,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
>>  
>>  		/*
>>  		 * Power down all ports by default, except the
>> -		 * console if we have one.
>> +		 * console (real or kgdb) if we have one.
>>  		 */
>> -		if (!uart_console(port))
>> +		if (!uart_console(port) && !uart_kgdb(port))
>>  			uart_change_pm(state, 3);
>>     
>
> Jason, thinking about this hunk again, it appears broken to me. If we
> needed it for 8250_kgdb, we would also need it without
> CONFIG_KGDB_CONSOLE. However, powering on the UART with a special dance
> after we took over with 8250_kgdb is a job that has to be done _there_,
> not by this hook here. So let's drop the whole serial_core.c hunk from
> this patch.
>
> Jan
>   
Chunk dropped and the patches are refreshed in the git archive.

Jason.

