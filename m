Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961Ab0ABFfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0ABFfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 00:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0ABFfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 00:35:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:50910 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0ABFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 00:35:17 -0500
Message-ID: <4B3EDB08.6080707@windriver.com>
Date: Fri, 01 Jan 2010 23:35:04 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: linux-next: Tree for December 31 (kgdb)
References: <20091231112314.a51e160b.sfr@canb.auug.org.au> <20091231110747.5efc1efa.randy.dunlap@oracle.com>
In-Reply-To: <20091231110747.5efc1efa.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jan 2010 05:35:04.0712 (UTC) FILETIME=[562F5880:01CA8B6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 31 Dec 2009 11:23:14 +1100 Stephen Rothwell wrote:
>
>   
>> Hi all,
>>
>> This one has also not had the build testing *between* merges, but has had
>> all the normal build testing at the end.There may be more unbisectable
>> points in the tree then usual.
>>
>> Changes since 20091230:
>>
>> My fixes tree is again empty with the equivalent of its patch being added
>> to Linus' tree.
>>     
>
>
> when CONFIG_PROC_FS is not enabled:
>
> kernel/built-in.o: In function `kdb_summary':
> kdb_main.c:(.text+0x6a413): undefined reference to `_meminfo_proc_show'
>
>
>   

Fixed.

> when CONFIG_KGDB_KDB is not enabled:
>
> kernel/built-in.o: In function `kdb_dmesg':
> kdb_main.c:(.text+0x6b5c4): undefined reference to `kdb_syslog_data'
>
>   

When CONFIG_KGDB_KDB is not set, it is not possible to compile
kdb_main.c.  This one was actually due to compiling a kernel with
CONFIG_PRINTK=n and CONFIG_KGDB_KDB=y.

It is fixed.

> when CONFIG_KDB_KEYBOARD is not enabled:
>
> drivers/built-in.o: In function `cleanup_kgdboc':
> kgdboc.c:(.text+0x1ee2df): undefined reference to `kdb_get_kbd_char'
> drivers/built-in.o: In function `configure_kgdboc':
> kgdboc.c:(.text+0x1ee463): undefined reference to `kdb_get_kbd_char'
>
>
>   
If CONFIG_KDB_KEYBOARD is not enabled there is no way to get these
functions.  This one was actually due to compiling CONFIG_KDB_KEYBOARD=y
and CONFIG_VT_CONSOLE=n.

It is fixed as well.

The changes are folded into the 2 offending patches in the kdb patches
in the kgdb-next branch for proper bisecting patches.

Thanks for the report.

Jason.
