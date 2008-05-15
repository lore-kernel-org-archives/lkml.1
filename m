Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYEOR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYEOR6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763663AbYEOR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:57:16 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49721 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763653AbYEOR5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:57:14 -0400
Date: Thu, 15 May 2008 23:28:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Mike Travis <travis@sgi.com>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel
	system)
Message-ID: <20080515175826.GA20418@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
	Mike Travis <travis@sgi.com>,
	Arjan van de Ven <arjan@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <20080505135215.GD5420@dirshya.in.ibm.com> <20080506120436.GH32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080506120436.GH32591@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-05-06 14:04:36]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > System topology on intel based system needs to be exported for 
> > non-numa case as well.
> > 
> > All parts of asm-i386/topology.h has come under 
> > #ifdef CONFIG_NUMA after the merge to asm-x86/topology.h
> > 
> > /sys/devices/system/cpu/cpu?/topology/* is populated based on 
> > ENABLE_TOPO_DEFINES
> > 
> > The sysfs cpu topology is not being populated on my dual socket
> > dual core xeon 5160 processor based (x86 32 bit) system.
> > 
> > CONFIG_NUMA is not set in my case yet the topology is relevant
> > and useful.
> > 
> > irqbalance daemon application depends on topology to build the cpus 
> > and package list and it fails on Fedora9 beta since the sysfs topology 
> > was not being populated in the 2.6.25 kernel.
> > 
> > I am not sure if it was intentional to not define ENABLE_TOPO_DEFINES 
> > for non-numa systems.
> > 
> > This fix has been tested on the above mentioned dual core, dual socket
> > system.
> 
> applied, thanks Vaidyanathan.
> 
> This was certainly not intentional - i suspect nobody noticed that 
> irqbalanced was working without proper topology information?

Hi Ingo,

Thank you for pushing the patch to 2.6.25-rc2.  I have tested
2.6.26-rc2  for correct topology information and parsing by irqbalance
daemon in the following system configurations:

32-bit Two socket dual core xeon 5160 processor system
32-bit Two socket quad core xeon E5450 processor system

--Vaidy

