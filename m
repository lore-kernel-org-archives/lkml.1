Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZDZQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZDZQg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZDZQgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:36:48 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:36183 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbZDZQgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:36:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8FADIo9ElMQW1W/2dsb2JhbACBUMhpg3QF
Date: Sun, 26 Apr 2009 12:31:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, stable@kernel.org, cpufreq@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Ben Slusky <sluskyb@paranoiacs.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq fix timer teardown in conservative governor
	(2.6.30-rc2)
Message-ID: <20090426163139.GA26154@Krystal>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424043546.GB8091@Krystal> <alpine.LFD.2.00.0904240217390.15843@localhost.localdomain> <20090424161217.GA25650@Krystal> <20090426144701.GD19338@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090426144701.GD19338@khazad-dum.debian.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:28:51 up 57 days, 12:55,  2 users,  load average: 1.18, 0.79,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Henrique de Moraes Holschuh (hmh@hmh.eng.br) wrote:
> On Fri, 24 Apr 2009, Mathieu Desnoyers wrote:
> > * Len Brown (lenb@kernel.org) wrote:
> > > Somebody please remind me why we are spending effort to 
> > > maintain the conservative governor instead of deleting it.
> > 
> > Documentation/cpu-freq/governors.txt
> > 
> > "The CPUfreq governor "conservative", much like the "ondemand"
> > governor, sets the CPU depending on the current usage.  It differs in
> > behaviour in that it gracefully increases and decreases the CPU speed
> > rather than jumping to max speed the moment there is any load on the
> > CPU.  This behaviour more suitable in a battery powered environment."
> > 
> > So better battery usage seems to be the reason why conservative lives.
> 
> Yeah, but the question is: is it really better in practice? race-to-idle
> works better with ondemand.  Note: that needs to be answered not just for
> the current crop of mobile processors, but also for at least stuff as old as
> the Pentium M and Pentium 4 M.
> 
> What it _does_ help, is in broken !@#$ hardware that makes a lot of noise
> due to "singing capacitors" if you use ondemand (because conservative will
> make less noise as it causes more smooth transitions).  NOHZ helped a great
> deal there, too.
> 

I effectively have such singing capacitors on my laptop, and I still
have good ears.

> I don't know if there are battery environments where a harsher work profile
> by the CPU are a bad idea.  If there are any, conservative will also help
> there.
> 

Good question. We might also consider that anyway code duplication
between ondemand and conservative is a bad thing. Those look so similar
that part of them should probably be merged, with a sysfs flag and
kernel parameter to select the behavior.

Mathieu


> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
