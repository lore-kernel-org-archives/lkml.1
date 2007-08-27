Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXH0UTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXH0UTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXH0UTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:19:46 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:64340 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728AbXH0UTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:19:45 -0400
Date: Mon, 27 Aug 2007 16:19:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each architecture
Message-ID: <20070827201941.GA5653@Krystal>
References: <20070827155234.062715780@polymtl.ca> <Pine.LNX.4.64.0708271234580.5026@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271234580.5026@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:12:09 up 28 days, 20:31,  4 users,  load average: 0.64, 0.34, 0.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Here is the patch series for 2.6.23-rc3-mm1 that adds cmpxchg_local, and now
> > also cmpxchg64_local, to each architecture.
> 
> Any planned uses of cmpxchg64_local? 

Let's say it could possibly eliminate the xtime read seqlock on x86
(should be investigated) and can be useful to overcome the
non-synchronized TSC handling when taking TSC-based timestamps. All
these operations require locking to play with 64 bits values on 32 bits
architectures, which could be improved by cmpxchg64_local.

But again, it would require some testing to see if we can improve
performances there.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
