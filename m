Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbXGKQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbXGKQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXGKQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:29:14 -0400
Received: from smtp-9.smtp.ucla.edu ([169.232.48.138]:58912 "EHLO
	smtp-9.smtp.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbXGKQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:29:12 -0400
Date: Wed, 11 Jul 2007 09:28:59 -0700 (PDT)
From: Chris Stromsoe <cbs@cts.ucla.edu>
To: Jiri Kosina <jikos@jikos.cz>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [git patches] net driver updates
In-Reply-To: <Pine.LNX.4.64.0707111128330.31463@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0707110920270.11697@potato.cts.ucla.edu>
References: <20070710183953.GA8898@havoc.gtf.org> <Pine.LNX.4.64.0707111128330.31463@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Probable-Spam: no
X-Spam-Report: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Jiri Kosina wrote:
> On Tue, 10 Jul 2007, Jeff Garzik wrote:
>
>> Various minor updates.  The only thing of note is sk98lin driver 
>> removal. Please pull from 'upstream-linus' branch of 
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git 
>> upstream-linus
>
> This is probably going to cause a new entry in regressions list, as at 
> least Chris Stromsoe has reported bonding-related problems with skge 
> that don't happen with sklin - 
> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0707.1/1158.html

It's worse than just bonding related.  This also causes a reliable hard 
lockup with skge:

fresno:~# modprobe skge
fresno:~# ip li set eth2 up
fresno:~# ip li set eth2 down
fresno:~# ip li set eth3 up

The server locks up there.  Nothing is printed to console and it takes a 
power cycle to fix the problem.

eth2 and eth3 are both ports on an SK-9844 dual-port card.  The test above 
is with 2.6.22.  I've also had it fail with .21.*, .20.*, and several 
other kernels.

fresno:~# uname -a
Linux fresno 2.6.22 #4 SMP Tue Jul 10 11:38:19 PDT 2007 i686 GNU/Linux

fresno:~# dmesg | grep skge
skge 1.11 addr 0xfebfc000 irq 22 chip Genesis rev 0
skge eth2: addr 00:00:5a:98:ac:8c
skge eth3: addr 00:00:5a:98:ac:8d

fresno:~# lspci -v -s 02:01
02:01.0 Ethernet controller: SysKonnect SK-9872 Gigabit Ethernet Server Adapter (SK-NET GE-ZX dual link) (rev 11)
         Subsystem: SysKonnect SK-9844 Gigabit Ethernet Server Adapter (SK-NET GE-SX dual link)
         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 22
         Memory at febfc000 (32-bit, non-prefetchable) [size=16K]
         I/O ports at e800 [size=256]
         Expansion ROM at febc0000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 1
         Capabilities: [50] Vital Product Data


-Chris

