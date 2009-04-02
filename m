Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbZDBHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbZDBHHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZDBHHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:07:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbZDBHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:07:15 -0400
Date: Thu, 02 Apr 2009 00:07:03 -0700 (PDT)
Message-Id: <20090402.000703.108386433.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: More problems in setup_pcpu_remap()
From: David Miller <davem@davemloft.net>
In-Reply-To: <49D45364.2010703@kernel.org>
References: <49D44251.4000606@kernel.org>
	<20090401.215233.134215150.davem@davemloft.net>
	<49D45364.2010703@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 02 Apr 2009 14:55:48 +0900

> David Miller wrote:
> > It would make more sense to carve up 2MB chunks into some-power-of-2
> > pieces and use that as the unit size.
> >
> > You could retain the NUMA goals of this function, as well as the
> > ability to be using 2MB pages in the TLBs.
> 
> Can you please elaborate a bit?
> 
> > And consider that if the dynamic allocation part of this code triggers
> > even once, you'll end up eating twice as much VMALLOC space.
> > 
> > Using 2MB per cpu is just rediculious, and really not even necessary.
> 
> The focus at the moment is using large page for the first chunk to
> reduce pressure on TLB, not necessarily actually using 2MB for each
> unit.

You'll get better TLB hit rates with my suggestion.

The idea is to carve up a 2MB page amongst consequetive cpus in
the same NUMA node.

With hyperthreading these cpus will be sharing the TLB, so you'll
get better TLB hit rates than the current code.

I'm going to do something like this on sparc64.  This x86 code is
severely demotivating me, so I'll stop looking at it now :-)
