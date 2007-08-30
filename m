Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXH3CNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXH3CNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 22:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXH3CNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 22:13:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:47165 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbXH3CNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 22:13:10 -0400
Message-ID: <46D627B6.9060208@windriver.com>
Date: Wed, 29 Aug 2007 21:13:10 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: pete@bluelane.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Kgdb-bugreport] 2.6.23-rc3-mm1: kgdb build failure on powerpc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<200708222104.29432.m.kozlowski@tuxland.pl>	<20070822124743.fc316963.akpm@linux-foundation.org>	<46CCBC3C.7010307@windriver.com> <20070822165318.b82da13c.akpm@linux-foundation.org> <46CCFE2C.4050306@windriver.com> <46D604BF.7090905@bluelane.com> <46D61B21.1010703@bluelane.com>
In-Reply-To: <46D61B21.1010703@bluelane.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2007 02:12:48.0452 (UTC) FILETIME=[42CF0840:01C7EAAB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete/Piet Delaney wrote:
> We are getting a problem with VMware where kernel text is the schedler
> is getting wacked with four null bytes into the code. Thought I'd use
> the current linux-2.6-kgdb.git tree and possible the CONFIG_DEBUG_RODATA
> patch to make kernel text readonly:
>
>  https://www.x86-64.org/pipermail/patches/2007-March/003666.html
>
> I thought the kernel text was RO and gdb had to disable it to
> insert a breakpoint.
>
>   

If you are going to make all the kernel text RO, then you are going to 
have to add some code to the kgdb write memory so as to unprotect a 
given page or all the breakpoint writes are going to fail.  
Alternatively you can use HW breakpoints.  But, I have no idea if your 
VM Ware simulated HW emulate HW breakpoint registers or not.

Jason.
