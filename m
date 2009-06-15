Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbZFOSyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbZFOSyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764528AbZFOSyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:54:13 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:49675 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764849AbZFOSyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:54:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAAcwNkpMQWQl/2dsb2JhbACBT9VwhA0F
Date: Mon, 15 Jun 2009 14:48:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615184858.GD6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A369508.2090707@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:47:15 up 107 days, 15:13,  3 users,  load average: 1.41, 1.44,
	1.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Linus Torvalds wrote:
> > 
> > On Mon, 15 Jun 2009, Ingo Molnar wrote:
> >> A simple cr2 corruption would explain all those cc1 SIGSEGVs and 
> >> other user-space crashes i saw, with sufficiently intense sampling - 
> >> easily.
> > 
> > Note that we could work around the %cr2 issue, since any corruption is 
> > always nicely "nested" (ie there are never any SMP issues with async 
> > writes to the register).
> > 
> > So what we _could_ do is to have a magic value for %cr2, along with a "NMI 
> > sequence count", and if we see that value, we just return (without doing 
> > anything) from the page fault handler.
> > 
> 
> Wouldn't it be simpler to just require the NMI handler to save and
> restore %cr2 around any potentially faulting references?
> 
> 	-hpa

If we require that around the whole NMI handler execution, then we get
all vmalloc + module text code references handled for free. This would
be a nice-to-have.a And given nmi-handler is not such a frequent code
path, we should not care that much about the performance hit of
saving/restoring the cr2 register at each nmi entry/exit.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
