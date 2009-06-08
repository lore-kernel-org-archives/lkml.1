Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZFHGdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZFHGdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZFHGdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:33:24 -0400
Received: from www.tglx.de ([62.245.132.106]:60426 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZFHGdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:33:23 -0400
Date: Mon, 8 Jun 2009 08:33:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <20090608141250.6a5735fa@feng-desktop>
Message-ID: <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop> <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain> <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop> <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain> <20090608141250.6a5735fa@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

On Mon, 8 Jun 2009, Feng Tang wrote:
> Our apbt driver is pretty similar with HPET's, including its cpu hotplug
> notifier. But our platform only has 2 available apbt to use, otherwise we will
> configure it just like HPET, using one timer as bc and others for per-cpu ones,
> then it won't hit this case
> 
> There are 2 situations, one is for the normal boot, apbt0 will be inited first
> and registered to OS as cpu0's timer, then tsc/lapic is calculated based on it,
> and apbt1 is registered later in a fs_initcall() (just like hpet.c does) after basic
> kernel core is up. so the sequence is:
> apbt0 --> lapic0 --> lapic1 --> apbt1

Hmm, I do not like that at all. That explicitely relies on CPU0 doing
some work which will kick CPU1. That's fragile as hell. 

Why do you want to make the CPU1 case special? You setup apbt0 before
you setup local APIC on CPU0, so why can't you do the same for apbt1
on CPU1 ? That will also remove the complete hotplug logic from your
code.

Thanks,

	tglx
