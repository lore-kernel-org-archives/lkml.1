Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYBETHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYBETHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYBETHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:07:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38248 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756005AbYBETHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:07:37 -0500
Date: Tue, 5 Feb 2008 11:07:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <20080205195511.b396ea4b.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802051104520.12425@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI> <47A81513.4010301@cosmosbay.com>
 <Pine.LNX.4.64.0802050952300.16488@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0802051007270.11705@schroedinger.engr.sgi.com>
 <20080205195511.b396ea4b.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Eric Dumazet wrote:

> > Well we could do the same as for numa stats. Output the global count and 
> > then add
> > 
> > c<proc>=count
> > 
> 
> Yes, or the reverse, to avoid two loops and possible sum errors (Sum of 
> c<proc>=count different than the global count)

The numa output uses only one loop and so I think we could do the same 
here. Its good to have the global number first that way existing tools can 
simply read a number and get what they intuitively expect.

> Since text##_show is going to be too big, you could use one function 
> instead of several ones ?

Sure.

> (and char *buf is PAGE_SIZE, so you should add a limit ?)

Yes we must do so because support for 4k processors etc is on the horizon.

> Note I used for_each_possible_cpu() here instead of 'online' variant, or 
> stats might be corrupted when a cpu goes offline.

Hmmm.. We are thinking about freeing percpu areas when a cpu goes offline. 
So we would need to fold statistics into another cpu if this is a cocnern. 

