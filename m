Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZCDMIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZCDMIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCDMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:08:12 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4144 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZCDMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:08:11 -0500
Date: Wed, 4 Mar 2009 07:07:59 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090304120759.GA6519@hash.localnet>
References: <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303200352.GA8343@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 08:03:52PM +0000, Sitsofe Wheeler wrote:
> The machine where this fault happened is a single core non-symmetric
> multithreading EeePC 900 with a Celeron M 900 using a voluntary preempt
> kernel (so I doubt this is due to tasklets being run on another CPU)...

This particular one could still happen on UP, provided interrupts were
enabled in ath5k_rx_start (I don't think that's very likely, though.  
I tried warning on that case and didn't hit it).

> I am a bit unsure which patches you want me to be testing though...

None.  Perhaps it's wishful thinking but a function trace for the few
minutes prior to the poison would be useful.  A good replicator might
be to run a sequence of automatic suspend/resume with pm_test, in 
parallel with iwlist wlan0 scan (as root, so scans are actually 
performed), in parallel with iperf or ping.  I didn't personally have
luck with that workload, though.

-- 
Bob Copeland %% www.bobcopeland.com

