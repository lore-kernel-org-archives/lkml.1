Return-Path: <linux-kernel-owner+w=401wt.eu-S1946719AbXD3T2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946719AbXD3T2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946717AbXD3T2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:28:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39806 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946724AbXD3T2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:28:09 -0400
Date: Mon, 30 Apr 2007 12:28:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Please revert [PATCH] user of the jiffies rounding patch: Slab
In-Reply-To: <46364017.2040009@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0704301221490.8075@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com> 
 <4633D1A2.6010002@linux.intel.com>  <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com>
 <1177803630.3477.3.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0704301042580.6343@schroedinger.engr.sgi.com>
 <46364017.2040009@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Arjan van de Ven wrote:

> Christoph Lameter wrote:
> > Umm you did not read the last bit of the description? It talks about firing
> > all timers on all cpus at once.
> >  
> 
> it talks about AVOIDING firing all timers on all cpus at once.

Hmmmm... Looked fine right now. Must have gotten the deep end before.

Ok. Could you review the new 1 HZ timer that I added to vmstat.c in mm and 
make sure that it does the right thing? I'd like to have that one run at 
an jiffy offset of 1 instead of 3 to give you more quiet time. 

That one is only used for SMP. With SLUB there will be no periodic timers 
at all for UP. SMP only has the vmstats update which should be quite 
lightweight compared to the slab reaper and it does not need this long 
period between them to be safe.

I'd like to have some ideas from you for NUMA. On NUMA I would like to 
have all vm statistics refresh actions on each node be synchronized (which 
would also significantly fix the situation on large NUMA for you).

I.e. on HZ the first cpus of each node run vmstats update, on HZ + 1 the 
second cpu run its etc. How could we make that work?


