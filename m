Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbYBGAqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbYBGAqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933952AbYBGAcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:32:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:62819 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933945AbYBGAcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:32:01 -0500
Message-ID: <47AA5165.4070201@windriver.com>
Date: Wed, 06 Feb 2008 18:31:33 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Kiszka <jan.kiszka@web.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] KGDB: Major refactoring
References: <47A8F275.9090901@web.de> <20080207001336.GA22986@elte.hu>
In-Reply-To: <20080207001336.GA22986@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2008 00:31:13.0251 (UTC) FILETIME=[BE4AEB30:01C86920]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Kiszka <jan.kiszka@web.de> wrote:
>
>   
>> As most changes are tightly coupled, this refactoring patch for
>> KGDB_8250 as well as the core and the new KGDBOC driver comes as a
>> single chunk. The changes are:
>>  - Reorganized configuration: I/O drivers can be independently
>>    configured as module or built-in
>>  - Dynamic reconfiguration for KGDB_8250 (just like for KGDBOC)
>>  - Reworked KGDB_8250 configuration string format
>>  - attachwait removed, arming the debugger via assigning an I/O driver
>>    implies "attachwait"
>>  - Cleaned up I/O driver managment of the core
>>  - Matured the various boot-up, configure, unconfigure code paths for
>>    both I/O drivers
>>  - IRQ vs. KGDB_CONSOLE-output SMP race fixed for KGDB_8250
>>  - Reduced and cleaned up hooks into serial_core/8250
>>  - Kconfig cleanups
>>     
>
> great stuff! I've picked these cleanups up into x86.git. (will pick up 
> Jason's commits too)
>
> Could you try something else too perhaps, which would be way useful for 
> me: to add a sysctl flag (or something like that) to change kgdboc to 
> accept a Ctrl-C and break into kgdb mode? [this means a simple Ctrl-C on 
> a kgdboc line would break into KGDB as well - but that would be an 
> acceptable price.] Right now kgdboc just hangs when gdb attaches - i 
> have to generate a SysRq sequence via a terminal emulator to break it 
> into KGDB mode.
>   

FYI, even if you were to hack in a control-c vs sysrq, gdb will still
hang on connect because it does not issue a break of any kind when it
connects.  It assumes the connection is in a usable state.

The proxy spliter automatically sends the break (or in the current case
the sysrq g)
> This would make kgdboc way more practical without having to resort to a 
> protocol splitting proxy, etc.
>
> 	Ingo
>   


Jason.
