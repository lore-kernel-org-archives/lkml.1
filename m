Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXFFByc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXFFByc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763383AbXFFByY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:54:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53080 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbXFFByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:54:23 -0400
Date: Tue, 5 Jun 2007 18:54:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051837310.23799@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051851350.7159@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051826310.6928@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051837310.23799@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> mems_allowed.  Regardless, we should not allow allocations outside of the 
> cpuset because we have marked it TIF_MEMDIE and we don't have any explicit 
> guarantee that it is exiting yet and not mlock'ing an excessive amount of 
> memory that exceeds the capacity of all cpuset nodes.

Hmmmm... But we have sent it a SIGKILL. If the process is following 
conventions then it is exiting. Of course the process could be abusing the 
system and attempting to OOM the whole system as an act of revenge for 
being killed but isnt this a bit far fetched?



