Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXC0RfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXC0RfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934062AbXC0RfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:35:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059AbXC0RfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:35:20 -0400
Message-ID: <460955CC.70006@redhat.com>
Date: Tue, 27 Mar 2007 13:35:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com,
       Thilo.Cestonaro.external@fujitsu-siemens.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> <4608AF01.4060804@goop.org> <460902CF.1030202@redhat.com> <46094A70.9080901@goop.org>
In-Reply-To: <46094A70.9080901@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
>
> diff -r 4c81d8cafb67 drivers/char/sysrq.c
> --- a/drivers/char/sysrq.c	Tue Mar 27 01:16:07 2007 -0700
> +++ b/drivers/char/sysrq.c	Tue Mar 27 01:18:05 2007 -0700
> @@ -408,6 +408,8 @@ void __handle_sysrq(int key, struct tty_
>  	int i;
>  	unsigned long flags;
>  
> +	softlockup_global_disable();
> +
>  	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>  	orig_log_level = console_loglevel;
>  	console_loglevel = 7;
> @@ -445,6 +447,8 @@ void __handle_sysrq(int key, struct tty_
>  		console_loglevel = orig_log_level;
>  	}
>  	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> +
> +	softlockup_global_enable();
>  }
>  
>   

I wonder if that's too strong of a fix.  It's only the sysrq-t case that 
is the problem.  AFAIK, none of the other sysrq-t operations hold the 
tasklist_lock for a long time.  I'd move these around show_state.

P.
