Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZKQDJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZKQDJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZKQDJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:09:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53672
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbZKQDJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:09:06 -0500
Date: Mon, 16 Nov 2009 19:09:22 -0800 (PST)
Message-Id: <20091116.190922.182816918.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: hpa@zytor.com, mingo@elte.hu, travis@sgi.com, tglx@linutronix.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com, rdreier@cisco.com,
       rdunlap@xenotime.net, tj@kernel.org, andi@firstfloor.org,
       gregkh@suse.de, yhlu.kernel@gmail.com, rientjes@google.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au,
       seto.hidetoshi@jp.fujitsu.com, steiner@sgi.com, fweisbec@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
 bootup messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091116215052.GK5653@lenovo>
References: <20091116214302.GJ5653@lenovo>
	<4B01C81F.9040000@zytor.com>
	<20091116215052.GK5653@lenovo>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 17 Nov 2009 00:50:52 +0300

> On Mon, Nov 16, 2009 at 01:46:07PM -0800, H. Peter Anvin wrote:
>> On 11/16/2009 01:43 PM, Cyrill Gorcunov wrote:
>> > 
>> > It seems we have one
>> > 
>> > 	arch/x86/kernel/setup.c:125:unsigned int boot_cpu_id __read_mostly;
>> > 
>> > 	-- Cyrill
>> 
>> We probably should make it an inline function so that if other arches
>> want to define it to be a constant or some other kind of special thing
>> they can.
>
> IA-64 and SPARC already has this variable. But boot_cpu_id() as an
> inline function seem to be more natural/portable ineed.

Only 32-bit SPARC actually has it.  On sparc64 we have no reason to
remember which processor was the boot cpu, and remembering it merely
for the sake of only printing out the bogomips message once seems a
bit excessive?

How about:

	static bool printed;

	if (!printed) {
		printk(...);
		printed = true;
	}

Or, alternatively, use an atomic_t instead of a bool if you think
races matter this early in the boot process.
