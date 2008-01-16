Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYAPHfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYAPHfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYAPHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:34:53 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:24963 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753582AbYAPHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:34:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DcniHc9wr0yx8S8UXe35D54vwnr7vBV3xAgVHw1k/PSHjLkE2HhoqrEzp7WRXQFqdNucta9sUjAOb3DT+iK4bR+iPwgIyFIUDEVv1CZABUp5fkwg8Hy+dEi4mYfXRoanPy6P8H74G8HgAulM9Rhcu25QUtidZdg5VkwuMQAXRXI=  ;
X-YMail-OSG: lPlupR0VM1lWY3RCkGCsmlXfakim_DAWO9rAMF_3yVdEWYBC4_sUiwgYs7VFDKO4aDm_KGnK0A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with large count NR_CPUs
Date: Wed, 16 Jan 2008 18:34:39 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080113183453.973425000@sgi.com> <20080114101133.GA23238@elte.hu> <200801141230.56403.ak@suse.de>
In-Reply-To: <200801141230.56403.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161834.39746.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 22:30, Andi Kleen wrote:

> In general there are more scaling problems like this (e.g. it also doesn't
> make sense to scale kernel threads for each CPU thread for example).

I think in a lot of ways, per-CPU kernel threads scale OK. At least
they should mostly be dynamic, so they don't require overhead on
smaller systems. On larger systems, I don't know if there are too
many kernel problems with all those threads (except for userspace
tools sometimes don't report well).

And I think making them per-CPU can be much easier than tuning some
arbitrary algorithm to get a mix between parallelism and footprint.

For example, I'm finding that it might actually be worthwhile to move
some per-node and dynamically-controlled thread creation over to the
basic per-CPU scheme because of differences in topologies...

Anyway, that's just an aside.

Oh, just while I remember it also, something funny is that MAX_NUMNODES
can be bigger than NR_CPUS on x86. I guess one can have CPUless nodes,
but wouldn't it make sense to have an upper bound of NR_CPUS by default?
