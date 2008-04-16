Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYDPEh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYDPEh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 00:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYDPEhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 00:37:09 -0400
Received: from 1wt.eu ([62.212.114.60]:3123 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYDPEhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 00:37:08 -0400
Date: Wed, 16 Apr 2008 06:27:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Anton Titov <a.titov@host.bg>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Bad network performance over 2Gbps
Message-ID: <20080416042742.GA25188@1wt.eu>
References: <1208282804.23631.27.camel@localhost> <20080415201441.GE8474@1wt.eu> <480512BD.3060407@intel.com> <1208298996.23631.43.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208298996.23631.43.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 01:36:36AM +0300, Anton Titov wrote:
> On Tue, 2008-04-15 at 13:40 -0700, Kok, Auke wrote:
> > Willy Tarreau wrote:
> > 1) turn the in-kernel IRQBALANCE option off !
> Actually it may be already removed. I remember it being under "Processor
> type and features" and I currently cannot find it there for x86_64
> 
> > 2) use either the userspace `irqbalance` daemon or
> > 3) set smp_affinity manually
> 
> I tried echoing 3 (assuming that CPU0 and CPU1 will share their cache,
> as advised in other mails) into smp_affinity of all ethX interrupts and
> no positive result was observed.

But have you disabled irqbalance before doing this ? (you must reboot
and pass "noirqbalance" on the command line for this).

Also, if you are running on quad-core intel CPUs, I'm told that they're
simply two standard dual-core CPUs in the same case, so there is no
shared cache between any core. You should try to assign all irqs to
CPU0 for a test. It *must* make a difference, in either direction.

> I will try disabling NAPI and limiting e1000 interrupts tomorrow.

I found the parameter name I was speaking about : InterruptThrottleRate.
Beware it's an array with one entry per NIC, so you have to set as many
values as you have NICs. I have always observed huge performance boosts
when using the tunables the driver provides.

Willy

