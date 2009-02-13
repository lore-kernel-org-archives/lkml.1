Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZBMOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZBMOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZBMOZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:25:31 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:38289 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbZBMOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:25:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FACcMlUlMQWt2/2dsb2JhbACBbtEvhBgG
Date: Fri, 13 Feb 2009 09:25:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090213142521.GB31922@Krystal>
References: <1234529407.6519.28.camel@twins> <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins> <20090213130450.GB9346@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090213130450.GB9346@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:22:00 up 43 days, 14:20,  4 users,  load average: 0.21, 0.33,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > I think I got a mostly working patch cobbled together sitting here
> > > somewhere. I was waiting for some _really_ good use case before spending
> > > more time on it. I would prefer if at all possible to do vmap operations
> > > in sleepable, process context.
> > 
> > Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> > ops yell louder at violations of these rules.
> > 
> > I'm just totally clueless wrt text_poke() hence this email ;-)
> 
> also, this started triggering yesterday for the first time - and never
> saw it before. Has some commit caused this side-effect?
> 
> It triggers during kprobes self-test - has that been improved recently?
> 

When is this self-test run ? If it's at early boot while still in UP
with interrupts off, kprobes should probably use text_poke_early()
rather than text_poke().

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
