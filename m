Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbXJXSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbXJXSVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXJXSUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:20:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:54404 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbXJXSUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:20:54 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EA6D7331-2E0E-44D5-A286-EFD3505139BB@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: handling watchdog in SMP
Date: Wed, 24 Oct 2007 13:21:37 -0500
To: Wim Van Sebroeck <wim@iguana.be>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was hoping to get some ideas on how to handle the watchdog timers  
we have on some embedded PPC (booke_wdt.c) cores when we are in a SMP  
system.

The problem is since the watchdog is part of the processor core  
depending on which processor a given system call is executed at we  
might get different behavior.  It seems like we would want to mirror  
the actions to both cores (via smp_call_function).

Looking at the file ops we currently support in booke_wdt.c it seems  
like we could mirror the actions for booke_wdt_write()/booke_wdt_ping 
() to both cores and ensure when we set something like  
WDIOC_SETTIMEOUT we set the registers in both processors.

I was wondering if anyone had any other ideas or if this model seems  
to work.

- k
