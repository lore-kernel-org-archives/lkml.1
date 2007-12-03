Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXLCMEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXLCMEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLCMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:04:05 -0500
Received: from www.tglx.de ([62.245.132.106]:50087 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXLCMEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:04:02 -0500
Date: Mon, 3 Dec 2007 13:03:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jakub Jelinek <jakub@redhat.com>
cc: Thomas Gleixner <tglx@www.tglx.de>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fedora's latest gcc produces unbootable kernels
In-Reply-To: <20071203115112.GT16835@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.0.9999.0712031302280.6765@localhost.localdomain>
References: <20071201154223.1b052d39@poseidon.drzeus.cx> <20071201184752.33536d09@poseidon.drzeus.cx> <20071201212054.2377c8be@poseidon.drzeus.cx> <23803.203.197.163.97.1196669842.squirrel@www.tglx.de> <20071203085817.GQ16835@devserv.devel.redhat.com>
 <alpine.LFD.0.9999.0712031231370.6765@localhost.localdomain> <20071203115112.GT16835@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Jakub Jelinek wrote:

> On Mon, Dec 03, 2007 at 12:34:17PM +0100, Thomas Gleixner wrote:
> > Of course just to annoy you :)
> 
> It doesn't matter whether I'm annoyed about this or not, but whether gcc is
> able to generate decent code with it or not.  And especially with union it
> is not, at least through all the tree ssa passes.  You already have a lot of
> the details hidden in ktime.h accessor inlines, so I don't think it would be
> hard to add further one or two.
> 
> Anyway, even just using typedef struct ktime { s64 tv64; } ktime_t; could
> make things better in case you have just one field.  Unlike unions, structs
> can be (and in this case most likely will be) scalarized by SRA, so
> half of tree SSA passes will see it as integral var and will be able to
> perform optimizations on it.

Makes sense. I look into fixing that.

Thanks,

	tglx
