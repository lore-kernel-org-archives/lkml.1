Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXJYTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXJYTbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXJYTa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:30:57 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:4314 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbXJYTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:30:56 -0400
X-Belgacom-Dynamic: yes
Date: Thu, 25 Oct 2007 21:37:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: handling watchdog in SMP
Message-ID: <20071025193702.GA6455@infomag.infomag.iguana.be>
References: <EA6D7331-2E0E-44D5-A286-EFD3505139BB@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA6D7331-2E0E-44D5-A286-EFD3505139BB@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> I was hoping to get some ideas on how to handle the watchdog timers  
> we have on some embedded PPC (booke_wdt.c) cores when we are in a SMP  
> system.
> 
> The problem is since the watchdog is part of the processor core  
> depending on which processor a given system call is executed at we  
> might get different behavior.  It seems like we would want to mirror  
> the actions to both cores (via smp_call_function).
> 
> Looking at the file ops we currently support in booke_wdt.c it seems  
> like we could mirror the actions for booke_wdt_write()/booke_wdt_ping 
> () to both cores and ensure when we set something like  
> WDIOC_SETTIMEOUT we set the registers in both processors.
> 
> I was wondering if anyone had any other ideas or if this model seems  
> to work.

I see 2 ways to go:
1) short term: make sure that your actions are duplicated to both cores
(like you said). At least then you are protected if your complete system
crashes.
2) I'm working on the uniform/generic watchdog device driver. Phase 1 is
the "new" api and the /dev/watchdog handling. Phase 2 is a sysfs interface.
Phase 3 is to allow multiple devices (and there I'm still thinking about
how the /dev/watchdog interface should work).
But the general idea is to allow at least the control of each watchdog
device by the sysfs interface.

Greetings,
Wim.

