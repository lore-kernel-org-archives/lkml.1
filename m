Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYCZXsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYCZXsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYCZXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:47:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:37334 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYCZXrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:47:55 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <20080326232922.GA15784@jurassic.park.msu.ru>
References: <47E969E1.6080608@m3y3r.de>
	 <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	 <20080326232922.GA15784@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:45:49 +1100
Message-Id: <1206575149.6926.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-27 at 02:29 +0300, Ivan Kokshaysky wrote:

> Well, at this point (pdev_sort_resources call) bridge resource->start
> has nothing to do with a bus address, it just a temporary storage for
> required alignment, filled by sizing routines (and 0 is definitely
> invalid here).

Allright, that sounds better then.

>  I know, this is quite confusing, but I didn't want to add extra
> fields to existing structures or create temporary per-bus trees...
> But after pci_assign_resource() that resource can certainly be at 0,
> depending on PCIBIOS_MIN_{IO,MEM} and free slots in the resource tree.

In fact, this is the resource assignment code, and PCIBIOS_MIN_* is set
to non-0 for powerpc too so we don't try to assign things down at 0
anyway, so we don't have a problem. We only care about things at 0 that
have already been put there by the firmware and that we decide not to
reassign.

So I don't have any objection anymore.

Cheers,
Ben.


