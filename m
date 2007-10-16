Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbXJPRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbXJPRVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXJPRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:21:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXJPRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:21:33 -0400
Date: Tue, 16 Oct 2007 19:21:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Yi Yang <yang.y.yi@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       crutcher+kernel@datastacks.com
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
	key
Message-ID: <20071016172124.GA19882@elf.ucw.cz>
References: <4714DDA8.8030204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4714DDA8.8030204@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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
> 
> SysRq Help Information:
> 
>   Hot Key      Function Description
> ===========    ====================
> ALT+SysRq+0    Changing Loglevel to this value
> ALT+SysRq+1    Changing Loglevel to this value
> ALT+SysRq+2    Changing Loglevel to this value
> ALT+SysRq+3    Changing Loglevel to this value
> ALT+SysRq+4    Changing Loglevel to this value
> ALT+SysRq+5    Changing Loglevel to this value
> ALT+SysRq+6    Changing Loglevel to this value
> ALT+SysRq+7    Changing Loglevel to this value
> ALT+SysRq+8    Changing Loglevel to this value
> ALT+SysRq+9    Changing Loglevel to this value
> ALT+SysRq+a    Not defined
> ALT+SysRq+b    Resetting
> ALT+SysRq+c    Trigger a crashdump
> ALT+SysRq+d    Not defined
> ALT+SysRq+e    Terminate All Tasks
> ALT+SysRq+f    Manual OOM execution
> ALT+SysRq+g    Not defined
> ALT+SysRq+h    Not defined
> ALT+SysRq+i    Kill All Tasks
> ALT+SysRq+j    Not defined
> ALT+SysRq+k    SAK
> ALT+SysRq+l    Not defined
> ALT+SysRq+m    Show Memory
> ALT+SysRq+n    Nice All RT Tasks
> ALT+SysRq+o    Power Off
> ALT+SysRq+p    Show Regs
> ALT+SysRq+q    Show Pending Timers
> ALT+SysRq+r    Keyboard mode set to XLATE
> ALT+SysRq+s    Emergency Sync
> ALT+SysRq+t    Show State
> ALT+SysRq+u    Emergency Remount R/O
> ALT+SysRq+v    Not defined
> ALT+SysRq+w    Show Blocked State
> ALT+SysRq+x    Not defined
> ALT+SysRq+y    Not defined
> ALT+SysRq+z    Not defined

This will scroll out of users view on small terminals.

Plus it is untrue. On sparc, it is stop+x, not sysrq+x.

> +/*
> + * Hot key table SysRq supports
> + */
> +static char __read_mostly sysrq_hot_key_table[36] = {
> +	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
> +	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
> +	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
> +	'u', 'v', 'w', 'x', 'y', 'z'
> +};

Plus this is practically guaranteed to get out of sync with
reality. If you did this to make sysrq printing faster... then that is
very bad optimization.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
