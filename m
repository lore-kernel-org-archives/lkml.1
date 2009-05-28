Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZE1OQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZE1OQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZE1OQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:16:51 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:55880 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZE1OQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xZSx8ytTVcTi58YLzP9yHLF43tcxM44vAuo2rD1jiuvIhvqCgz6YzUxalOO6q287Zr
         3sfG3WeZxjxhm4SDTcRtQKZo+06Fcdf4dF0upppjMVI6S2csE5knE96yyv5kAgYV8FM3
         lkW1gksHwBEYu3axMUBKisLrTkSCEmL36vruU=
Date: Thu, 28 May 2009 16:16:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: annotate emit_log_char() notrace
Message-ID: <20090528141648.GA6018@nowhere>
References: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:00:44PM +0200, Thomas Gleixner wrote:
> printk calls emit_log_char() in a loop which is cluttering the trace
> buffer. Make it notrace.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---


Does it produce that much annoying traces?
I mean, printk() are usually rare events.

Do you have a particular debugging workflow that makes this
function invasive in the trace?

May be it's because you are debugging using ftrace and other
debugging options that use a lot of printk()
In such case, it would indeed be good to apply this patch.

Thanks,
Frederic.



>  kernel/printk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/kernel/printk.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/printk.c
> +++ linux-2.6-tip/kernel/printk.c
> @@ -499,7 +499,7 @@ static void call_console_drivers(unsigne
>  	_call_console_drivers(start_print, end, msg_level);
>  }
>  
> -static void emit_log_char(char c)
> +static void notrace emit_log_char(char c)
>  {
>  	LOG_BUF(log_end) = c;
>  	log_end++;

