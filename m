Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYEFMFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYEFMFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYEFMEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:04:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYEFMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:04:54 -0400
Date: Tue, 6 May 2008 14:04:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Mike Travis <travis@sgi.com>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [BUG] sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel
	system)
Message-ID: <20080506120436.GH32591@elte.hu>
References: <20080505135215.GD5420@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505135215.GD5420@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> System topology on intel based system needs to be exported for 
> non-numa case as well.
> 
> All parts of asm-i386/topology.h has come under 
> #ifdef CONFIG_NUMA after the merge to asm-x86/topology.h
> 
> /sys/devices/system/cpu/cpu?/topology/* is populated based on 
> ENABLE_TOPO_DEFINES
> 
> The sysfs cpu topology is not being populated on my dual socket
> dual core xeon 5160 processor based (x86 32 bit) system.
> 
> CONFIG_NUMA is not set in my case yet the topology is relevant
> and useful.
> 
> irqbalance daemon application depends on topology to build the cpus 
> and package list and it fails on Fedora9 beta since the sysfs topology 
> was not being populated in the 2.6.25 kernel.
> 
> I am not sure if it was intentional to not define ENABLE_TOPO_DEFINES 
> for non-numa systems.
> 
> This fix has been tested on the above mentioned dual core, dual socket
> system.

applied, thanks Vaidyanathan.

This was certainly not intentional - i suspect nobody noticed that 
irqbalanced was working without proper topology information?

	Ingo
