Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYBYRp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYBYRp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYBYRpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:45:50 -0500
Received: from mx-1.enea.se ([192.36.1.70]:14153 "EHLO mx-1.enea.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYBYRpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:45:49 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 12:45:49 EST
Message-ID: <47C2FB39.3080508@enea.com>
Date: Mon, 25 Feb 2008 18:30:33 +0100
From: Arvid Brodin <arvid.brodin@enea.com>
Organization: Enea
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Print long messages to console from kernel module
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2008 17:29:33.0005 (UTC) FILETIME=[FC04FFD0:01C877D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to write messages > 1023 characters long to the console from a module*. printk() is limited to 1023 characters, and splitting the message over several printk()'s results in a line break and "Month hh:mm:ss host kernel:" being inserted in my text.

I tried including <linux/console.h> and using the console_drivers declared there, but get
"WARNING: "console_drivers" [<path>/log.ko] undefined!" when compiling and
"insmod: error inserting 'log.ko': -1 Unknown symbol in module" when insmodding.

I guess this is because non EXPORT_SYMBOL'd symbols are only accessible to statically linked code, and not to modules? I see in printk.c that console_drivers is set up there, and I haven't been able to find any other interface to console_drivers.

In short: is there any way to print messages to the console from a kernel module, except printk()? Is opening /dev/tty and writing to it the way to go?


* I'm writing an in-memory logger to be included in a module. The log can be several megabytes. The idea is to use SysRq to print the contents of the log to console after a kernel panic or otherwise when writing to disk might not work.

-- 
Arvid Brodin
Enea LCC
