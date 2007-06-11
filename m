Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXFKQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXFKQK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXFKQKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:10:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57360 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbXFKQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:10:11 -0400
Date: Mon, 11 Jun 2007 09:10:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <466C2915.3080706@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0706110908440.15326@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0706081531161.3966@schroedinger.engr.sgi.com>
 <20070608224539.GA9851@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0706081553030.4332@schroedinger.engr.sgi.com>
 <466C2915.3080706@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Arjan van de Ven wrote:

> Christoph Lameter wrote:
> > On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:
> > 
> > > > What functionality are you missing in the page allocator? It seems that
> > > > is does what you want?
> > > Humm..I basically want to allocate memory during interrupt context and
> > > expect not to fail. I know this is a hard requirement :)
> > 
> > The page allocator can do that for you. The reserves are configurable. Not
> > failing is a thing unseen in the computer world.
> 
> but the page allocator reserve is shared.. and you will need this one EXACTLY
> when the shared pool is getting low... it's not an uncorrelated thing!

I think what needs to be done first is to define under what conditions the 
allocation should not fail. There is certainly no way to have GFP_ATOMIC 
allocation that never fail. After all memory is limited and at some point 
we need to reclaim memory.
 
