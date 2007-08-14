Return-Path: <linux-kernel-owner+w=401wt.eu-S936564AbXHNWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936564AbXHNWWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763425AbXHNWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:16:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49245 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbXHNWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:16:18 -0400
Date: Wed, 15 Aug 2007 00:16:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814221616.GG23308@one.firstfloor.org>
References: <20070814204454.GC22202@one.firstfloor.org> <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com> <20070814212355.GA23308@one.firstfloor.org> <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com> <20070814212955.GC23308@one.firstfloor.org> <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com> <20070814214430.GD23308@one.firstfloor.org> <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com> <20070814215659.GF23308@one.firstfloor.org> <Pine.LNX.4.64.0708141504350.32420@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141504350.32420@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 03:07:10PM -0700, Christoph Lameter wrote:
> There are more spinlocks needed. So we would just check the whole bunch 
> and fail if any of them are used?

Yes zone_flag would apply to all of them.

> 
> > 		do things with zone locks 
> > 	}
> > 
> > The interrupt handler shouldn't touch zone_flag. If it wants
> > to it would need to be converted to a local_t and incremented/decremented
> > (should be about the same cost at least on architectures with sane
> > local_t implementation) 
> 
> That would mean we need to fork the code for reclaim?

Not with the local_t increment.

-Andi
