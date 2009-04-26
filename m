Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZDZOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZDZOrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZDZOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:47:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46490 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbZDZOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:47:06 -0400
X-Sasl-enc: ApQyNseLnyqQoLcxzTwUnkmF1Z80u40r0AqiUHphdk1P 1240757225
Date: Sun, 26 Apr 2009 11:47:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, stable@kernel.org, cpufreq@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Ben Slusky <sluskyb@paranoiacs.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq fix timer teardown in conservative governor
	(2.6.30-rc2)
Message-ID: <20090426144701.GD19338@khazad-dum.debian.net>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424043546.GB8091@Krystal> <alpine.LFD.2.00.0904240217390.15843@localhost.localdomain> <20090424161217.GA25650@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424161217.GA25650@Krystal>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Mathieu Desnoyers wrote:
> * Len Brown (lenb@kernel.org) wrote:
> > Somebody please remind me why we are spending effort to 
> > maintain the conservative governor instead of deleting it.
> 
> Documentation/cpu-freq/governors.txt
> 
> "The CPUfreq governor "conservative", much like the "ondemand"
> governor, sets the CPU depending on the current usage.  It differs in
> behaviour in that it gracefully increases and decreases the CPU speed
> rather than jumping to max speed the moment there is any load on the
> CPU.  This behaviour more suitable in a battery powered environment."
> 
> So better battery usage seems to be the reason why conservative lives.

Yeah, but the question is: is it really better in practice? race-to-idle
works better with ondemand.  Note: that needs to be answered not just for
the current crop of mobile processors, but also for at least stuff as old as
the Pentium M and Pentium 4 M.

What it _does_ help, is in broken !@#$ hardware that makes a lot of noise
due to "singing capacitors" if you use ondemand (because conservative will
make less noise as it causes more smooth transitions).  NOHZ helped a great
deal there, too.

I don't know if there are battery environments where a harsher work profile
by the CPU are a bad idea.  If there are any, conservative will also help
there.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
