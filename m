Return-Path: <linux-kernel-owner+w=401wt.eu-S935136AbXHNTnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbXHNTnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXHNTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:42:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932759AbXHNTmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:42:45 -0400
Date: Tue, 14 Aug 2007 12:42:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lucio Correia <ljhc@br.ibm.com>
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <1187106239.3298.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
 <1187106239.3298.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Lucio Correia wrote:

> > SLAB boots because it falls back to node 0 for the control structures. So 
> > it creates useless control structures for node 1. These are then never 
> > used since any allocation  attempt to node 1 falls back to node 0.
> 
> Hi Christoph,
> 
> Shouldn't SLUB falls back to other node also for the case it can't
> allocate memory? 

Yes SLUB will fall back but not during bootstrap. Bootstrap needs to 
carefully place structures on the right nodes. We fail during bootstrap 
because there is *no* memory available on it.
