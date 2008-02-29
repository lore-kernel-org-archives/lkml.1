Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbYB2O52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbYB2O52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYB2O5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:57:21 -0500
Received: from mx-1.enea.se ([192.36.1.70]:25159 "EHLO mx-1.enea.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYB2O5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:57:20 -0500
Message-ID: <47C81DA6.8040100@enea.com>
Date: Fri, 29 Feb 2008 15:58:46 +0100
From: Arvid Brodin <arvid.brodin@enea.com>
Organization: Enea
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Print long messages to console from kernel module
References: <47C2FB39.3080508@enea.com>
In-Reply-To: <47C2FB39.3080508@enea.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Feb 2008 14:57:18.0604 (UTC) FILETIME=[612504C0:01C87AE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things have cleared a bit. First, my problem is with printing to console.
Second, the date-time-host header is only appended when using loglevel
KERN_DEBUG. Third, the <n> tag is only appended to the beginning of the printk
printout if the last printout did not end with a '\n'. The whole printk code is
quite confuscated IMO, not the least so call_console_drivers(), so this could be
a feature, however it looks to me like the loglevel tag is for internal use and
my guess is it should never be printed on the console at all.

I'll look into filing a bug report and patch for this. At the moment the best
solution seems to be to search through the log I want to print and cut the
printout after every '\n'. That should take care of most of the "<n>"'s.

-- 
Arvid Brodin
Enea LCC


On 2008-02-25 18:30, Arvid Brodin wrote:
> I need to write messages > 1023 characters long to the console from a module*. printk() is limited to 1023 characters, and splitting the message over several printk()'s results in a line break and "Month hh:mm:ss host kernel:" being inserted in my text.
> 
> I tried including <linux/console.h> and using the console_drivers declared there, but get
> "WARNING: "console_drivers" [<path>/log.ko] undefined!" when compiling and
> "insmod: error inserting 'log.ko': -1 Unknown symbol in module" when insmodding.
> 
> I guess this is because non EXPORT_SYMBOL'd symbols are only accessible to statically linked code, and not to modules? I see in printk.c that console_drivers is set up there, and I haven't been able to find any other interface to console_drivers.
> 
> In short: is there any way to print messages to the console from a kernel module, except printk()? Is opening /dev/tty and writing to it the way to go?
> 
> 
> * I'm writing an in-memory logger to be included in a module. The log can be several megabytes. The idea is to use SysRq to print the contents of the log to console after a kernel panic or otherwise when writing to disk might not work.
> 
