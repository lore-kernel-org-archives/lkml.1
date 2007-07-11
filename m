Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXGKVsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXGKVsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760804AbXGKVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:48:31 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:35426 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676AbXGKVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:48:30 -0400
Date: Wed, 11 Jul 2007 17:43:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: akpm@linux-foundation.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Linux Kernel Markers
Message-ID: <20070711214320.GA24487@Krystal>
References: <20070703170843.204442953@polymtl.ca> <y0mir8zr4ny.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mir8zr4ny.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:36:08 up 4 days, 11:41,  2 users,  load average: 0.16, 0.67, 0.87
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > This updated version of the Linux Kernel Markers mostly adds a unique 16 bits
> > per marker ID and a per-probe marker group. [...]
> 

Hello,

> Could you motivate this part better?  It is not covered in the
> documentation patch.
> 
> It seems to be a way of having a marker handling (callback) module
> give alternate names/ids to markers.  If so, why, considering that
> there is already a private void* callback parameter available to pass
> data back to itself through?
> 

The original reason was to get rid of a supplementary kmalloc() for each
active marker. However, I just noticed that I could pack my private data
in a slab cache, which makes the problem go away. I am therefore
removing IDs and groups from the markers.. they don't really belong to
this low-level infrastructure anyway, so this is all better.

> Also, what if different marker handling modules want to set different
> id/group numbers on the same set of markers?
> 

The way I see things now is to provide the simplest way to do the job,
without over-design. Clearly, putting the IDs and groups there was not
the best idea. I also think it will be up to a "tee" callback module to
implement a list of handlers (notifiers). However, supporting such a
list of handlers should not be a requirement for the low-level markers,
since has a significant performance impact which can be unwanted in the
common case (only one probe connected to a marker).

Mathieu

> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
