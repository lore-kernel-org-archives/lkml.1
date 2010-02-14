Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0BNLIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:08:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56418 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab0BNLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:08:43 -0500
Date: Sun, 14 Feb 2010 12:08:40 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 08/10] ARM: ftrace: fix and update dynamic ftrace
Message-ID: <20100214110840.GA21357@pengutronix.de>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-9-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266090518-31120-9-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Feb 14, 2010 at 01:18:36AM +0530, Rabin Vincent wrote:
> This adds mcount recording and updates dynamic ftrace for ARM to work
> with the new ftrace dyamic tracing implementation.  It also adds support
> for the mcount format used by newer ARM compilers.
> 
> With dynamic tracing, mcount() is implemented as a nop.  Callsites are
> patched on startup with nops, and dynamically patched to call to the
> ftrace_caller() routine as needed.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/include/asm/ftrace.h  |   19 +++++-
>  arch/arm/kernel/entry-common.S |   37 +++++++---
>  arch/arm/kernel/ftrace.c       |  155 +++++++++++++++++++++++++++------------
>  scripts/recordmcount.pl        |    2 +
>  4 files changed, 155 insertions(+), 58 deletions(-)
> 
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index 103f7ee..4a56a2e 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -2,12 +2,29 @@
>  #define _ASM_ARM_FTRACE
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> -#define MCOUNT_ADDR		((long)(mcount))
> +#define MCOUNT_ADDR		((unsigned long)(__gnu_mcount_nc))
hhmm, does this work with both the old and the new mcount function?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
