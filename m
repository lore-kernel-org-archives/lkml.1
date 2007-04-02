Return-Path: <linux-kernel-owner+w=401wt.eu-S966007AbXDBWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007AbXDBWh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966002AbXDBWh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:37:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40460 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965966AbXDBWh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:37:57 -0400
Date: Mon, 2 Apr 2007 15:37:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Dave Hansen <hansendc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704030031.24898.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704021534100.25602@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
 <1175550968.22373.122.camel@localhost.localdomain> <200704030031.24898.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Andi Kleen wrote:

> If it works I would be inclined to replaced old sparsemem with Christoph's
> new one on x86-64. Perhaps that could cut down the bewildering sparsemem
> ifdef jungle that is there currently.
> 
> But I presume it won't work on 32bit because of the limited address space?

Not in general but it will work in non PAE mode. 4GB need 2^(32-21+4) = 
16MB pages. This would require the mapping on 4 4MB pages.

For 64GB you'd need 256M which would be a quarter of low mem. Probably 
takes up too much of low mem.

> > But, without some cold, hard, data, we mere mortals without the 1024-way
> > machines can only guess. ;)
> 
> Yep.
> 
> -Andi (who would be scared of a 1024 way x86 machine)

- Christoph (who does not believe that Andi has to wait long for 
something bigger)

