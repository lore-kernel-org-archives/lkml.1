Return-Path: <linux-kernel-owner+w=401wt.eu-S1422892AbXCOPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422892AbXCOPT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXCOPTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:19:55 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:48536 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422892AbXCOPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:19:55 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: fake config option w/kbuild?
Date: Thu, 15 Mar 2007 10:19:03 -0500
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, I was wondering if there was a way to have a fake config  
option, one that acts just like a normal config option, but doesn't  
get a #define CONFIG_<FOOBAR> .. for it and thus can't be used in code.

I explain my problem, and maybe there is a better solution.

I have a config option call QE that exists on two flavor's of  
powerpc.  For PPC, we have one top level menu to select the processor  
(in this case 83xx or 85xx).  We than have a second top level menu to  
select the platform (which board).  The platform menu is where I want  
the 'QE' option to exist.  Each flavor (83xx, 85xx) has its own  
Kconfig that defines what's in the platform menu.  However, the QE  
config choice is common between them.

So for now we are doing something like:

arch/powerpc/Kconfig:

config QE
	bool
	default n

arch/powerpc/platform/83xx/Kconfig:

config QE_83xx
	bool "QUICC Engine Support"
         select QE
         depends on PPC_MPC836x || PPC_MPC832x
         default y
         ---help---
           The QUICC Engine (QE) is a new generation of communications
           coprocessors on Freescale embedded CPUs (akin to CPM in  
older chips).

arch/powerpc/platform/85xx/Kconfig:

config QE_85xx
	bool "QUICC Engine Support"
         select QE
         depends on PPC_MPC8568
         default y
         ---help---
           The QUICC Engine (QE) is a new generation of communications
           coprocessors on Freescale embedded CPUs (akin to CPM in  
older chips).

My initial question is that I don't want anyone using CONFIG_QE_83xx  
or CONFIG_QE_85xx in code, the second part is if there is a way to  
remove duplicating the QE_83xx/QE_85xx options down in platform/8{3,5} 
xx/Kconfig.

thanks

- kumar
