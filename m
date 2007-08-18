Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXHRD0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXHRD0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 23:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXHRD0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 23:26:01 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:57471 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbXHRD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 23:26:00 -0400
Date: Fri, 17 Aug 2007 23:25:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Simple Performance Counters: Core Piece
Message-ID: <20070818032558.GB28293@Krystal>
References: <11859243123373-git-send-email-clameter@sgi.com> <20070817164251.GA1004@Krystal> <Pine.LNX.4.64.0708171340060.9404@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708171340060.9404@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:22:35 up 19 days,  3:41,  2 users,  load average: 3.12, 1.62, 0.74
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Fri, 17 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Actually, get_cycles() at least on some AMD cpus, do not synchronize the
> > core, which can skew the results. You might want to use
> > get_cycles_sync() there.
> 
> get_cycle() results as used here are bound to a single processor. If we 
> end up on a different processor at the end of the measurement then the 
> result is discarded. So not need for get_cycles_sync.
> 

I may be wrong, but I think the UP case still needs to synchronize the
core to have precise measurement. This sync core will make sure that
rdtsc is not executed speculatively. It therefore makes sure it is not
misplaced in the instruction stream. I therefore don't think this is a
SMP special case.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
