Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZJZHCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZJZHCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZJZHCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:02:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZJZHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:02:16 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
From: Andi Kleen <andi@firstfloor.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233746.128967000@alcatraz.americas.sgi.com>
Date: Mon, 26 Oct 2009 08:02:13 +0100
In-Reply-To: <20091023233746.128967000@alcatraz.americas.sgi.com> (Mike Travis's message of "Fri, 23 Oct 2009 18:37:44 -0500")
Message-ID: <87tyxmy6x6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> With a large number of processors in a system there is an excessive amount
> of messages sent to the system console.  It's estimated that with 4096
> processors in a system, and the console baudrate set to 56K, the startup
> messages will take about 84 minutes to clear the serial port.
>
> This patch adds (for SGI UV only) a kernel start option "limit_console_
> output" (or 'lco' for short), which when set provides the ability to
> temporarily reduce the console loglevel during system startup.  This allows
> informative messages to still be seen on the console without producing
> excessive amounts of repetious messages.
>
> Note that all the messages are still available in the kernel log buffer.

I've run into the same problem (kernel log being flooded on large number of CPU thread
systems). It's definitely not a UV only problem. Making such a option UV only
is definitely not the right approach, if anything it needs to be for everyone.

Frankly a lot of these messages made sense for debugging at some point,
but really don't anymore and should just be removed.

Also I don't like the defaults of on. It would be better to evaluate if
these various messages are really useful and if they are not just remove them.

For example do we really need the scheduler debug messages by default?

Or do we really need to print the caches for each CPU at boot? The information
is in sysfs anyways and rarely changes (I added this originally on 64bit,
but in hindsight it was a bad idea)

I don't think it makes much sense to print more than 2-3 lines for each CPU boot
for example.

Also more work could be done to make CPU boot up less verbose without
sacrifying debuggability if something goes wrong.

So please:
- Simply remove messages that don't make sense, no flag.
- Make the default non verbose.
- Minimize output in general, with just a few standard checkpoints so 
that if there is a hang the developer still has some clue what went wrong.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
