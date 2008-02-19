Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYBSQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYBSQw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbYBSQwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:52:11 -0500
Received: from www.tglx.de ([62.245.132.106]:56483 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbYBSQwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:52:10 -0500
Date: Tue, 19 Feb 2008 17:51:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
In-Reply-To: <20080219140552.GC9965@elte.hu>
Message-ID: <alpine.LFD.1.00.0802191748110.7583@apollo.tec.linutronix.de>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de> <20080219100029.GA1637@elf.ucw.cz>
 <20080219140552.GC9965@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Ingo Molnar wrote:
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC 
> > means _require_ TSC), but it is not properly disabled when it is 
> > unusable, because acpi code understood the config switch as "may use 
> > TSC".
> > 
> > This actually fixes suspend problems on my x60.
> 
> ah! This makes tons of sense. I've applied your patch - but i guess it 
> should go via the ACPI tree.

Right. The breakage was introduced there when IA64 switched to
GENERIC_TIME and the X86_TSC dependency was added.

Thanks,

	tglx
