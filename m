Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbXLCMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbXLCMfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLCMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:35:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:62742 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXLCMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TmV2HFr4FpI3c1kZbfWLBIxy97WInKTqCmMOW7ruWdHf5T/0xntRlxYxaY77gTCNfC5mnTMKC0xT0jpQAylHugBnPUIXIxYsqDSvGGNRpT93VA/vdMnTUidA6a1Kw9cT1e3RPP6zvJOf5B151eGDTBo+C8hYAJBVZ+IuXtPagNo=
Subject: Re: Kernel Development & Objective-C
From: Gilboa Davara <gilboad@gmail.com>
To: LKML Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@argo.co.il>
In-Reply-To: <47539030.10600@argo.co.il>
References: <474EAD18.6040408@stellatravel.co.uk>
	 <20071130143445.GA2310@csclub.uwaterloo.ca>
	 <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	 <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de>
	 <47539030.10600@argo.co.il>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 14:35:31 +0200
Message-Id: <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-03 at 07:12 +0200, Avi Kivity wrote:
> Andi Kleen wrote:
> > Avi Kivity <avi@argo.co.il> writes:
> >   
> >> [I really doubt there are that many of these; syscall
> >> entry/dispatch/exit, interrupt dispatch, context switch, what else?]
> >>     
> >
> > Networking, block IO, page fault, ... But only the fast paths in these 
> > cases. A lot of the kernel is slow path code and could probably
> > be written even in an interpreted language without much trouble.
> >
> >   
> 
> Even these (with the exception of the page fault path) are hardly "we 
> care about a single instruction" material suggested above.  Even with a 
> million packets per second per core (does such a setup actually exist?)  
> You have a few thousand cycles per packet.  For block you'd need around 
> 5,000 disks per core to reach such rate

Intel's newest dual 10GbE NIC can easily (?) throw ~14M packets per
second. (theoretical peak at 1514bytes/frame)
Granted, installing such a device on a single CPU/single core machine is
absurd - but even on an 8 core machine (2 x Xeon 53xx/54xx / AMD
Barcelona) it can still generate ~1M packets/s per core.

Now assuming you're doing low-level (passive) filtering of some sort
(frame/packet routing, traffic interception and/or packet analysis)
using hardware assistance (TSO, complete TCP offloading, etc) is off the
table and each and every cycle within netif_receive_skb (and friends)
-counts-.

I don't suggest that the kernel should be (re)designed for such (niche)
applications but on other hand, if it works...

- Gilboa

