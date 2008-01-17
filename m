Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYAQAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYAQAu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYAQAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:50:12 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19471 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYAQAuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:50:07 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Subject: Re: [PATCH 1/4] RT: remove duplicate time/Kconfig
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <20080116004051.GF30532@goodmis.org>
References: <1200435525.4092.14.camel@bx740>
	 <20080116004051.GF30532@goodmis.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 16:46:38 -0800
Message-Id: <1200530798.3939.17.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 00:47:42.0161 (UTC) FILETIME=[910DDC10:01C858A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 19:40 -0500, Steven Rostedt wrote:
> On Tue, Jan 15, 2008 at 02:18:45PM -0800, Frank Rowand wrote:
> > 
> > Index: linux-2.6.24-rc7/arch/mips/Kconfig
> > ===================================================================
> > --- linux-2.6.24-rc7.orig/arch/mips/Kconfig
> > +++ linux-2.6.24-rc7/arch/mips/Kconfig
> > @@ -1775,8 +1775,6 @@ config NR_CPUS
> >  	  performance should round up your number of processors to the next
> >  	  power of two.
> >  
> > -source "kernel/time/Kconfig"
> > -
> 
> This doesn't apply with -rt2. Are you sure you have the right tree?
> 
> -- Steve

As you suspected, I pulled this one from the wrong tree.  The correct
patch is below.

-Frank

> 
> >  #
> >  # Timer Interrupt Frequency Configuration
> 

time/Kconfig added by preempt-realtime-mips.patch duplicates other entry,
resulting in kernel make error:

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/mips/Kconfig |    2 	0 +	2 -	0 !
 1 files changed, 2 deletions(-)

Index: linux-2.6.24-rc7/arch/mips/Kconfig
===================================================================
--- linux-2.6.24-rc7.orig/arch/mips/Kconfig
+++ linux-2.6.24-rc7/arch/mips/Kconfig
@@ -1001,8 +1001,6 @@ config BOOT_ELF64
 
 menu "CPU selection"
 
-source "kernel/time/Kconfig"
-
 choice
 	prompt "CPU type"
 	default CPU_R4X00



