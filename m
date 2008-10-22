Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYJVS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYJVS5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbYJVSzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:55:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44479 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbYJVSzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:55:46 -0400
Date: Wed, 22 Oct 2008 14:55:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 03/11] ftrace: return error on failed modified text.
In-Reply-To: <20081022185135.952553961@goodmis.org>
Message-ID: <alpine.DEB.1.10.0810221454200.25366@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.952553961@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Steven Rostedt wrote:
> -			break;
> -		}
> +	ret = ftrace_modify_code(ip, call, nop);
> +	if (ret) {
> +		WARN_ON_ONCE(1);
> +		pr_info("ftrace failed to modify ");
> +		print_ip_sym(ip);
> +		print_ip_ins(" expected: ", call);
> +		print_ip_ins(" replace: ", nop);
> +		printk(KERN_CONT "\n");
> +		break;

This break is an error. I refreshed it in patch 5/11 by mistake.

-- Steve

>  
>  		rec->flags |= FTRACE_FL_FAILED;
>  		return 0;
> 
> -- 
> 
> 
