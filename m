Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXHRDU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXHRDU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 23:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXHRDUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 23:20:19 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:49572 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbXHRDUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 23:20:18 -0400
Date: Fri, 17 Aug 2007 23:20:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Simple Performance Counters: SLUB instrumentation
Message-ID: <20070818032015.GA28293@Krystal>
References: <1185924312685-git-send-email-clameter@sgi.com> <20070817162154.GB30922@Krystal> <Pine.LNX.4.64.0708171338440.9404@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708171338440.9404@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:18:38 up 19 days,  3:37,  2 users,  load average: 0.43, 0.37, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Fri, 17 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Why do you printk inside the timing period ? Filling the printk buffers
> > or outputting on things such as serial console could really hurt your
> > results.
> 
> It was easier to code?
> 
> > I hope you run your system with idle=poll and without frequency scaling
> > at all, because otherwise your cycle count would be completely off on
> > many AMD and Intel CPUs. You can have a look at this (very rough)
> > document on the topic: 
> 
> The cpu will definitely not be idle during these measurements and no 
> frequency scaling is active.

The problem is that if the cpu is idle _before_ the measurements, the
frequency will change differently from one cpu to another. Therefore,
the cycle counters may have large offsets when you start your tests. So,
if get_cycles() is executed on different CPUs (thread being migrated)
between the beginning and the end of the test, the results would be
skewed.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
