Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYFFLVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYFFLVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYFFLVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:21:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19534 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYFFLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HN+4wGytskBCb5E2Dj4uQOv1tlUwYQSQe50MgYsuuLALA252GZG2Mrlt68OxGyP0UW
         S+Tw9bj6iMRZ9WaXBtFUJdSVDE5Ah9nGXogQISqZqtOiXca90rdxymE2gUKJ/+gfIbgn
         Gp7ZznVEs4RTLvXy8f7oqELxlfdwf1lp6Ka7U=
Message-ID: <19f34abd0806060421y5ec0a4f7je592f6ba5b575ee4@mail.gmail.com>
Date: Fri, 6 Jun 2008 13:21:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for June 5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080606035413.37f340ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	 <20080605195604.41623687.akpm@linux-foundation.org>
	 <20080606071707.GB9708@elte.hu>
	 <20080606002957.6329a0ec.akpm@linux-foundation.org>
	 <20080606024811.70db9ab2.akpm@linux-foundation.org>
	 <20080606035413.37f340ef.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 12:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 6 Jun 2008 02:48:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

...

> commit a9ad585c8a18f7ba754b85f5786976609b9d7d29
> Author: Mike Travis <travis@sgi.com>
> Date:   Mon May 12 21:21:12 2008 +0200
>
>    x86: remove the static 256k node_to_cpumask_map
>
>      * Consolidate node_to_cpumask operations and remove the 256k
>        byte node_to_cpumask_map.  This is done by allocating the
>        node_to_cpumask_map array after the number of possible nodes
>        (nr_node_ids) is known.
>
>      * Debug printouts when CONFIG_DEBUG_PER_CPU_MAPS is active have
>        been increased.  It now shows faults when calling node_to_cpumask()
>        and node_to_cpumask_ptr().

This might be obvious, but maybe enabling CONFIG_DEBUG_PER_CPU_MAPS
will give you some more (valuable) info? It looks to me like maybe
nr_node_ids is returning inconsistent numbers or used somewhere before
it's properly initialized.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
