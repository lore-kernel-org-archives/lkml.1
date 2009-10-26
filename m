Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZJZRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZJZRz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZJZRz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:55:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38641 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752465AbZJZRz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:55:28 -0400
Message-ID: <4AE5E293.6090703@sgi.com>
Date: Mon, 26 Oct 2009 10:55:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <20091024010906.GA4938@nowhere>
In-Reply-To: <20091024010906.GA4938@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Fri, Oct 23, 2009 at 06:37:44PM -0500, Mike Travis wrote:
>> With a large number of processors in a system there is an excessive amount
>> of messages sent to the system console.  It's estimated that with 4096
>> processors in a system, and the console baudrate set to 56K, the startup
>> messages will take about 84 minutes to clear the serial port.
>>
>> This patch adds (for SGI UV only) a kernel start option "limit_console_
>> output" (or 'lco' for short), which when set provides the ability to
>> temporarily reduce the console loglevel during system startup.  This allows
>> informative messages to still be seen on the console without producing
>> excessive amounts of repetious messages.
>>
>> Note that all the messages are still available in the kernel log buffer.
> 
> 
> 
> Well, this problem does not only concerns SGI UV but all boxes with a large
> number of cpus.
> 
> Also, instead of adding the same conditionals in multiple places to solve
> the same problem (and that may even expand if we go further the SGI UV case,
> for example with other archs cpu up/down events), may be can you centralize,
> institutionalize this issue by using the existing printk mechanisms.
> 
> I mean, may be that could be addressed by adding a new printk
> level flag, and then associate the desired filters against it.
> 
> KERN_CPU could be a name, since this is targetting cpu events.
> 

I did try out something like this but the changes quickly became very intrusive,
and I was hoping for a "lighter" touch.  The other potential fallout of adding
another printk level might affect user programs that sift through the dmesg
log for "interesting" info.

Also, I could use some other config option to enable this, it's just that the
existing X86_UV was too convenient.  ;-)  I believe most systems would want this
turned off so the code size shrinks.  And until you get the number of cpus into
the hundreds and thousands, the messages usually just fly by - particularly if
you're on a desktop system which has almost an infinite baud rate to the screen,
and usually hides the messages behind a splash screen anyways.
