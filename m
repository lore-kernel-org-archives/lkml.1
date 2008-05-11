Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYEKN63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYEKN63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbYEKN6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:58:15 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:56362 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756696AbYEKN6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:58:13 -0400
Message-ID: <4826FBB8.7060107@seznam.cz>
Date: Sun, 11 May 2008 15:59:20 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Arnd Bergmann <arnd@arndb.de>, John Williams <john.williams@petalogix.com>,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: OF files
References: <5257.8247-18740-1017760922-1209828638@seznam.cz> <18467.60177.91772.136339@cargo.ozlabs.ibm.com>
In-Reply-To: <18467.60177.91772.136339@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I move prom_parse.c to drivers/of.
of_platform.c was completely moved to drivers/of/platform.c
Functions from of_device.c was moved to drivers/of/device.c except
of_device_make_bus_id.
Prom.c file was cleaned - I remove all PPC specific code.

You can check it in my git tree (git.monstr.eu) or wait for next set of patches.

Michal

> Michal Simek writes:
> 
>> I tested OF files changes. I sent you some patches about.
>>
>> I look at headers files too. Is it possible to move prom.h,
>> of_device.h and of_platform.h to asm-generic or linux folder? 
> 
> We can move stuff to drivers/of and include/linux, but we should only
> move the parts that are truly architecture-independent.  We should not
> have anything like #ifdef CONFIG_PPC_PSERIES in the files in those
> directories.  If it needs an ifdef like that, then that part of the
> file should stay under arch/powerpc.
> 
> In other words, it's OK to split files and end up with more files than
> we have at present.  That's better than adding ifdefs.
> 
> Paul.
> 
