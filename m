Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYDAHV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYDAHV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYDAHVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:21:19 -0400
Received: from www.tglx.de ([62.245.132.106]:36694 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYDAHVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:21:18 -0400
Date: Tue, 1 Apr 2008 09:20:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Michlmayr <tbm@cyrius.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
In-Reply-To: <20080331144415.GA2604@deprecation.cyrius.com>
Message-ID: <alpine.LFD.1.10.0804010913160.3219@apollo.tec.linutronix.de>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
 <20080331095729.GI28821@deprecation.cyrius.com> <alpine.LFD.1.10.0803311213020.3219@apollo.tec.linutronix.de> <20080331144415.GA2604@deprecation.cyrius.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Martin Michlmayr wrote:
> * Thomas Gleixner <tglx@linutronix.de> [2008-03-31 12:17]:
> > > I've attached all of that information.
> > 
> > Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config ? If
> > yes, can you please disable it and check whether the problem persists ?
> 
> CONFIG_NET_POLL_CONTROLLER was indeed set.  When I disable it, the
> problem goes away.
> 
> What does that mean?

E1000e does in e1000_netpoll():

       disable_irq(adapter->pdev->irq); 
       ...
       enable_irq(adapter->pdev->irq); 

The network card interrupt is rerouted to a legacy interrupt on
irq_disable(), in your case irq 19.

Sigh, there is not much we can do about that...

@Jon: Any idea ? Can you please gather some more info about that
oddity. It will come back... :(

Thanks,

	tglx
