Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZCFJnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZCFJnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZCFJmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:42:55 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43745 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZCFJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:42:54 -0500
Date: Fri, 6 Mar 2009 09:42:49 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090306094249.GA10236@silver.sucs.org>
References: <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304120759.GA6519@hash.localnet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 07:07:59AM -0500, Bob Copeland wrote:
> On Tue, Mar 03, 2009 at 08:03:52PM +0000, Sitsofe Wheeler wrote:
> 
> None.  Perhaps it's wishful thinking but a function trace for the few
> minutes prior to the poison would be useful.  A good replicator might
> be to run a sequence of automatic suspend/resume with pm_test, in 
> parallel with iwlist wlan0 scan (as root, so scans are actually 
> performed), in parallel with iperf or ping.  I didn't personally have
> luck with that workload, though.

Forcing the scans and pings didn't seem to make the issue occur.
Unfortunately I can't quite provide you what you were asking for...  I
started the function_tracer feature in /sys/kernel/debug/tracing and put
the buffer size to 153600kb (previously I had set it higher and
successfully OOMd my box : ). Unfortunately I had no filter so this was
not enough for all that long of a log (maybe about 6 seconds). I had a
small script that did the following:

watch -n1 'if `tail -1000 /var/log/kern.log | grep -q Poison`; then echo
0 > /sys/kernel/debug/tracing/tracing_on; cat
/sys/kernel/debug/tracing/trace | gzip > /tmp/trace.txt.gz ; fi'

(the script is obviously flawed but it did the job)

I've put up results on http://sucs.org/~sits/test/eeepc-debug/20090306/
and I think the type that kmalloc notices is 4154504125.579778 . There
is also a pre grepped log of (ieee|ath5k) in that directory.

I'll try and act on your filtering suggestions next time but I didn't
have too much time to get this going...

-- 
Sitsofe | http://sucs.org/~sits/
