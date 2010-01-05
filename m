Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329Ab0AEWX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0AEWX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704Ab0AEWXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:23:55 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:61401 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab0AEWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:23:54 -0500
Date: Tue, 5 Jan 2010 17:23:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 0/4] Remove local_t
Message-ID: <20100105222351.GA29675@Krystal>
References: <20100105220417.400092933@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100105220417.400092933@quilx.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:15:32 up 20 days,  6:34,  5 users,  load average: 0.50, 0.27,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Current -next has only the trace subsystem left as a user of local_t
> 
> Tracing uses local_t for per cpu safe atomic operations in the form
> of cmpxchg and additions. We already have a cmpxchg_local but no "local"
> form of addition.
> 
> The patchset introduces a similar local primitive add_local() and then
> uses cmpxchg_local() and add_local() to remove local_t use from the
> trace subsystem.
> 
> The last patch removes local_t support from the kernel tree.
> 
> The support for add_local() is pretty basic. We can add more
> fancy inc/dec variants and more optimization in the next
> revision of the patchset.
> 

Hi Christoph,

Yes, removing the local_t type could make sense. However, local_t maps
to a volatile long, not just "long". Secondly, I am concerned about the
fact that the patch you propose:

- does not create the primitives I use in lttng
- only deals with x86

In lttng (which is out of tree, but widely used), I need the equivalent
of:

local_read
local_set
local_add
local_cmpxchg
local_add_return
local_inc

The approach of just doing the x86 implementation and leaving all the
other architectures "for later" with a slow/non atomic generic fallback
is, imho, a no-go, given that some people (myself, actually) already
took the time to go through all the kernel architectures to create the
optimized local.h headers. Basically, you are destroying all that work,
asking for it to be done all over again.

I therefore argue that we should keep local.h as-is as long as the
replacement lacks the wide architecture support and primitive variety
found in local.h.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
