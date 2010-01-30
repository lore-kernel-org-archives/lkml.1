Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145Ab0A3B7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0A3B7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 20:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125Ab0A3B7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 20:59:47 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:54345 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0A3B7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 20:59:46 -0500
Subject: Re: debug: nt_conntrack and KVM crash
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <1264816634.2793.505.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 29 Jan 2010 20:59:37 -0500
Message-Id: <1264816777.2793.510.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 20:57 -0500, Jon Masters wrote:

> Ah so I should have realized before but I wasn't looking at valid values
> for the range of the hashtable yet, nf_conntrack_htable_size is getting
> wildly out of whack. It goes from:
> 
> (gdb) print nf_conntrack_hash_rnd
> $1 = 2688505299
> (gdb) print nf_conntrack_htable_size
> $2 = 16384
> 
> nf_conntrack_events: 1
> nf_conntrack_max: 65536
> 
> Shortly after booting, before being NULLed shortly after starting some
> virtual machines (the hash isn't reset, whereas it is recomputed if the
> hashtable is re-initialized after an intentional resizing operation):

I mean the *seed* isn't changed, so I don't think it was resized
intentionally. I wonder where else htable_size is fiddled with.

Jon.


