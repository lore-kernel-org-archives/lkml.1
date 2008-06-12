Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYFLPHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYFLPHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYFLPHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:07:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56528 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYFLPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:07:34 -0400
Date: Thu, 12 Jun 2008 09:07:16 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jes Sorensen <jes@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jeremy Higdon <jeremy@sgi.com>,
       Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080612150716.GX30405@parisc-linux.org>
References: <1211852026.3286.36.camel@pasglop> <4843C3D7.7000609@sgi.com> <200806031433.12460.nickpiggin@yahoo.com.au> <200806030952.10360.jbarnes@virtuousgeek.org> <4847A690.302@sgi.com> <1212655433.9496.109.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212655433.9496.109.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 06:43:53PM +1000, Benjamin Herrenschmidt wrote:
> Note that the powerpc implementation currently clears the flag
> on spin_lock and tests it on unlock. We are considering changing
> that to not touch the flag on spin_lock and just clear it whenever
> we do a sync (ie, on unlock, on explicit mmiowb, and possibly even
> on readl's where we happen to do sync's).

Your current scheme sounds like it's broken for

spin_lock(a)
writel();
spin_lock(b);
spin_unlock(b);
spin_unlock(a);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
