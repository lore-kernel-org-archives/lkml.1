Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZGFRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZGFRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZGFRmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:42:02 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54027 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZGFRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:42:01 -0400
Date: Mon, 6 Jul 2009 11:42:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Rick Jones <rick.jones2@hp.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       Jeff Garzik <jeff@garzik.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090706174203.GV5480@parisc-linux.org>
References: <20090705040137.GA7747@gondor.apana.org.au> <4A522D9A.1090006@hp.com> <BC02C49EEB98354DBA7F5DD76F2A9E800357D5A0C5@azsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E800357D5A0C5@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 10:36:11AM -0700, Ma, Chinang wrote:
> For OLTP workload we are not pushing much network throughput. Lower network latency is more important for OLTP performance. For the original Nehalem 2 sockets OLTP result in this mail thread, we bound the two NIC interrupts to cpu1 and cpu9 (one NIC per sockets). Database processes are divided into two groups and pinned to socket and each processe only received request from the NIC it bound to. This binding scheme gave us >1% performance boost pre-Nehalem date. We also see positive impact on this NHM system.

So you've tried spreading the four RX and TX interrupts for each card
out over, say, CPUs 1, 3, 5, 7 for eth1 and then 9, 11, 13, 15 for eth0,
and it produces worse performance than having all four tied to CPUs 1
and 9?  Interesting.

Can you try changing IGB_MAX_RX_QUEUES (in drivers/net/igb/igb.h, about
line 60) to 1, and seeing if performance improves that way?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
