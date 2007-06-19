Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXFSVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXFSVA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXFSVAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:00:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21834 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXFSVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:00:48 -0400
Subject: Re: [PATCH RT] disable preemption on running show all regs.
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1182284276.15228.25.camel@localhost.localdomain>
References: <1182284276.15228.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 13:57:13 -0700
Message-Id: <1182286634.18168.48.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 16:17 -0400, Steven Rostedt wrote:
> The show all regs sysrq uses the nmi function to do it. But this
> function expects preemption to be off, or funny things happen.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-2.6.21-rt9/drivers/char/sysrq.c
> ===================================================================
> --- linux-2.6.21-rt9.orig/drivers/char/sysrq.c
> +++ linux-2.6.21-rt9/drivers/char/sysrq.c
> @@ -213,7 +213,9 @@ static struct sysrq_key_op sysrq_showreg
>  
>  static void sysrq_handle_showallregs(int key, struct tty_struct *tty)
>  {
> +        preempt_disable();
>  	nmi_show_all_regs();
> +        preempt_enable();
>  }

Looks like you have a whitespace issue here.. Should be tabs, not
spaces.

Daniel

