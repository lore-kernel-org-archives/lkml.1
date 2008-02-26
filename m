Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYBZM57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYBZM57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYBZM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:57:52 -0500
Received: from mx-1.enea.se ([192.36.1.70]:43787 "EHLO mx-1.enea.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYBZM5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:57:51 -0500
Message-ID: <47C40D0F.9080708@enea.com>
Date: Tue, 26 Feb 2008 13:58:55 +0100
From: Arvid Brodin <arvid.brodin@enea.com>
Organization: Enea
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Print long messages to console from kernel module
References: <47C2FB39.3080508@enea.com> <Pine.LNX.4.61.0802251722400.2031@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0802251722400.2031@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2008 12:57:49.0469 (UTC) FILETIME=[30C494D0:01C87877]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-02-25 23:27, linux-os (Dick Johnson) wrote:
> On Mon, 25 Feb 2008, Arvid Brodin wrote:
> 
>> I need to write messages > 1023 characters long to the console from a module*. printk() is limited to 1023 characters, and splitting the message over several printk()'s results in a line break and "Month hh:mm:ss host kernel:" being inserted in my text.
>>
>> I tried including <linux/console.h> and using the console_drivers declared there, but get
>> "WARNING: "console_drivers" [<path>/log.ko] undefined!" when compiling and
>> "insmod: error inserting 'log.ko': -1 Unknown symbol in module" when insmodding.
>>
>> I guess this is because non EXPORT_SYMBOL'd symbols are only accessible to statically linked code, and not to modules? I see in printk.c that console_drivers is set up there, and I haven't been able to find any other interface to console_drivers.
>>
>> In short: is there any way to print messages to the console from a kernel module, except printk()? Is opening /dev/tty and writing to it the way to go?
>>
>>
>> * I'm writing an in-memory logger to be included in a module. The log can be several megabytes. The idea is to use SysRq to print the contents of the log to console after a kernel panic or otherwise when writing to disk might not work.
>>
> 
> Write the data to a kernel buffer. Impliment read() or ioctl() and
> poll(). Have a user-mode task sleep in poll, waiting for data to
> become available. That user-mode task can do anything it wants,
> unrestricted, with the data including writing it to files or any
> tty it wants to open.

Thank you for your answer. However, I don't see how a user-mode task will help me print my log after a kernel panic, through SysRq? Please clarify.

What we want is essentially a replacement for printk(), where the messages are instead logged in a big ring buffer, and can be printed with Alt-SysRq-l when need be. And the problem is the actual printing of the buffer to the console, since printk() inserts its timestamp after every linebreak or 1023 characters, whichever comes first.

-- 
Arvid Brodin
Enea LCC

