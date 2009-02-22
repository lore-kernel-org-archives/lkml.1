Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZBVRCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZBVRCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBVRCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:02:06 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46746 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZBVRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:02:05 -0500
Date: Sun, 22 Feb 2009 17:02:01 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222170201.GA27360@silver.sucs.org>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222144742.GA6078@nowhere>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 03:47:44PM +0100, Frederic Weisbecker wrote:
> On Sun, Feb 22, 2009 at 12:20:36PM +0000, Sitsofe Wheeler wrote:
> > On Sun, Feb 22, 2009 at 01:01:21PM +0100, Jiri Slaby wrote:
> > > The unsupported jumbo message might be a clue. When we jump to the next: 
> > > label, the buffer is at the end of the list in software, while in 
> > > hardware it isn't. In theory, we might hit the bug with rx buffers 
> > > exhaustion, because the test (bf_last == bf) doesn't work as expected then.
> > 
> > This seems to be happening somewhat regularly now - I've got a small
> > collections of the warnings (I'll include them below in case they are
> > any help):
> > 
> > [ 7435.711659] ath5k phy0: unsupported jumbo
> > [ 8125.567136] ath5k phy0: noise floor calibration timeout (2417MHz)
> > [ 9596.212322] ath5k phy0: unsupported jumbo
> > [10697.497598] ath5k phy0: unsupported jumbo
> > [11207.740975] =============================================================================
> > [11207.740986] BUG kmalloc-4096: Poison overwritten
> > [11207.740991] -----------------------------------------------------------------------------
> > [11207.740994] 
> > [11207.740999] INFO: 0xd7060010-0xd7060053. First byte 0x80 instead of 0x6b
> > [11207.741014] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=4990 cpu=0 pid=0
> > [11207.741023] INFO: Freed in skb_release_data+0x5e/0x90 age=893 cpu=0 pid=508
> > [11207.741030] INFO: Slab 0xc133dd80 objects=7 used=5 fp=0xd7060000 flags=0x400020c3
> > [11207.741036] INFO: Object 0xd7060000 @offset=0 fp=0xd70640c0

> Looks like it happens with ath5k driver.
> Well, I have an atheros card, so I'm testing it.

Good luck! I've just switched to a different location (with faster wifi
and more single network access points ) and I've been totally unable to
reproduce this warning.

If there's some debug output that I produce that will help you let me
know...

-- 
Sitsofe | http://sucs.org/~sits/
