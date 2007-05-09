Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbXEIRb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbXEIRb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXEIRbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:31:21 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668AbXEIRbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:31:20 -0400
Date: Wed, 9 May 2007 10:31:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - 100% CPU on ksoftirqd/1
Message-Id: <20070509103118.4ae14d83.akpm@linux-foundation.org>
In-Reply-To: <4123.1178726923@turing-police.cc.vt.edu>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<4123.1178726923@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 12:08:43 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
> Boots up to multiuser mostly OK.  However...
> 
> It comes up with a screaming ksoftirqd - usually /1 but one boot had /0.

erp.

> Just sitting there, 100% CPU according to 'top'.  Tried 'echo t > /proc/sysrq-trigger' to get
> a trace, but it was always running on the other CPU - even after I reniced
> it down to 19 and launched 2 'for(;;)' C programs to suck the cycles.  It would
> be failing to get any CPU - until I did the 'echo t' and then it would be
> "running" again.  Anybody got any good debugging ideas here?
> 
> Oddly enough, the kernel panic I was seeing at X server shutdown, related to
> -x86_64-mm-reloc64-__pa-and-__pa_symbol-address-space-separation.patch,
> seems to be gone now (not extensively tested - but it did survive one shutdown
> without crashing at a point that *had* been a 100% fatal from -rc5-mm3 to 21-mm1.
> I wish I understood why.
> 
> Replicated with a boot to single-user and an untainted kernel - by that point,
> it was spinning at 100% already.
> 
> Any ideas how to debug this one?  
> 

Sure, a kernel profile will tell us.

readprofile -r
sleep 5
readprofile -n -v -m /boot/System.map | sort -n -k 3 | tail -40

or

#!/bin/sh
opcontrol --stop
opcontrol --shutdown
rm -rf /var/lib/oprofile
opcontrol --vmlinux=/boot/vmlinux-$(uname -r)
opcontrol --start-daemon
opcontrol --start
sleep 5
opcontrol --stop
opcontrol --shutdown
opreport -l /boot/vmlinux-$(uname -r) | head -50


