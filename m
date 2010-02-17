Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0BQRyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:54:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:57342 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0BQRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:54:18 -0500
Message-ID: <4B7C2D24.4030608@windriver.com>
Date: Wed, 17 Feb 2010 11:53:40 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 18/28] powerpc,kgdb: Introduce low level
 trap catching
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-19-git-send-email-jason.wessel@windriver.com><1266190167.16346.70.camel@pasglop>  <4B7AF321.8060008@windriver.com> <1266360977.16346.245.camel@pasglop>
In-Reply-To: <1266360977.16346.245.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2010 17:53:40.0607 (UTC) FILETIME=[2384C8F0:01CAAFFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Almost, just stick a blank line here:
>
> +               /* Debugger is first in line to stop recursive faults in
> +                * rcu_lock, notify_die, or atomic_notifier_call_chain */
> +               if (debugger_bpt(regs))
> +                       return;
> ----> 
>                 /* trap exception */
>                 if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
>                                 == NOTIFY_STOP)
>                         return;
>
> Please :-)
>
>   

Done and pushed to kgdb-next.

Thanks,
Jason.
