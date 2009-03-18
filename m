Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZCRQAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZCRQAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCRQA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:00:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55090 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZCRQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:00:29 -0400
Subject: Re: C/R review
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <49C0CAB9.3080500@cs.columbia.edu>
References: <20090317210110.GA3897@x200.localdomain>
	 <49C0CAB9.3080500@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:00:08 -0700
Message-Id: <1237392008.8286.149.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 06:19 -0400, Oren Laadan wrote:
> >> +The checkpoint image format is composed of records consisting of a
> >> +pre-header that identifies its contents, followed by a payload. (The
> >> +idea here is to enable parallel checkpointing in the future in which
> >> +multiple threads interleave data from multiple processes into a single
> >> +stream).
> > 
> > I have my doubts about parallel checkpoint especially how large container
> > should be to need this and how much more complex code will it results in.
> 
> Doubts about the need ?   if I recall correctly IBM expressed interest in
> checkpointing containers with hundreds/thousands of processes that are
> spread among tens and hundreds of CPUs (multi-processor machine).

At the same time, I'd throw this kind of feature out the window in a
second if it meant getting a smaller or more understandable patch.  It
certainly isn't needed now.

Alexey, I'm really just assuming here, but I'd guess that a normal VPS
has a memory footprint between hundreds of MB or a few GB, right?  We're
also talking completely about RAM contents being moved here because all
the other data is a very small portion of the whole.  Unless creating
the checkpoint is maxing out one CPU, the entire problem this is solving
has to do with I/O bandwidth and availability.

If we really have I/O bandwidth problems, we should probably solve that
at the I/O level and not the checkpoint level.

My only other concern would be on systems with really high NUMA ratios.
A parallel checkpoint there just makes sense because shipping everything
across an interconnect could get really expensive.  We could move the
checkpoint process around to each node as we checkpoint its stuff, but
it would be a little silly to do a serial checkpoint on 1000 NUMA nodes
like that.

Anyway, I do think we should just concentrate on a single-stream
checkpoint for now.  We have a lot of other problems to solve before we
get to 1000 node NUMA machines.

-- Dave

