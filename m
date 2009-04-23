Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZDWNUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZDWNUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZDWNTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:19:55 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:49372 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbZDWNTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:19:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4LAPMC8ElMQW1W/2dsb2JhbACBT5VSuQ6CLoFHBg
Date: Thu, 23 Apr 2009 09:19:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090423131941.GA11261@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca> <20090423080645.GF22606@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090423080645.GF22606@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:17:26 up 54 days,  9:43,  1 user,  load average: 0.62, 0.36,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > " // Opteron Rev E has a bug in which on very rare occasions a locked
> >   // instruction doesn't act as a read-acquire barrier if followed by a
> >   // non-locked read-modify-write instruction.  Rev F has this bug in 
> >   // pre-release versions, but not in versions released to customers,
> >   // so we test only for Rev E, which is family 15, model 32..63 inclusive.
> 
> Dunno. The fix looks a bit intrusive (emits a NOP even on good 
> CPUs). Also, the text above says "not in versions released to 
> customers".
> 
> So unless there's an official erratum or reports in the field (not 
> from early prototype systems shipped to developers) i'd not rush to 
> apply it, just yet.
> 

Actually, Operon Rev E has this bug in the field (family 15, model
32..64). Rev F only had the bug in pre-releases.

But yes, it's bad that it drags so many code additions to something as
critical as cmpxchg. I start to think it might be better to just
disallow bringing up more than one CPU on these machines.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
