Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbXJPQCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbXJPQCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXJPQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:01:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:40058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbXJPQBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:01:48 -0400
From: Andreas Schwab <schwab@suse.de>
To: Yi Yang <yang.y.yi@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       pavel@atrey.karlin.mff.cuni.cz, crutcher+kernel@datastacks.com
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef key
References: <4714DDA8.8030204@gmail.com>
X-Yow: BARRY..  That was the most HEART-WARMING rendition of
 ``I DID IT MY WAY'' I've ever heard!!
Date: Tue, 16 Oct 2007 18:01:45 +0200
In-Reply-To: <4714DDA8.8030204@gmail.com> (Yi Yang's message of "Tue\, 16 Oct
	2007 23\:50\:00 +0800")
Message-ID: <jewstnhwuu.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang <yang.y.yi@gmail.com> writes:

> For SysRq, we just can get hot key list from Documentation/sysrq.txt
> , but in the most of cases, the user can't access it by hand on
> using SysRq to debug, so it is better for SysRq to provide an online
> help for the users.
>
> SysRq has already provided a similiar help before this patch, but it
> is not so definite that the user doesn't know what happened and how
> to do on pressing an undefined hot key.
>
> In addition, that funtion has a big loop with another big loop
> embedded which is very inefficient, it is intended to skip some hot
> key help info for such a function as "Changing Loglevel", just print
> a help info for this, that is very unnecessary. In fact, the key '0'
>  - '8' have different results the user should know.
>
> This patch add this online help function, it'll print thw whole hot
> key list and corresponding function descriptions, it can print the new
> defined hot key without any changed needed.
>
> The output is the below on pressing an undefined hot key:
>
> SysRq : <6>this hot key isn't defined.
          ^^^

This is misplaced.

> @@ -410,7 +420,7 @@ void __handle_sysrq(int key, struct tty_
>  	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>  	orig_log_level = console_loglevel;
>  	console_loglevel = 7;
> -	printk(KERN_INFO "SysRq : ");
> +	printk(KERN_INFO "\nSysRq : ");

It does not make any sense to put the printk level just before the
newline, since the newline resets it to the default level.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
