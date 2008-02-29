Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbYB2NEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbYB2NEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYB2NDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:03:55 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:64181 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbYB2NDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:03:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAI+Rx0dMQWoK/2dsb2JhbACBVqtx
Date: Fri, 29 Feb 2008 08:03:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and
	freeoffset
Message-ID: <20080229130348.GA9714@Krystal>
References: <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com> <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com> <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com> <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com> <20080229033255.GA2200@Krystal> <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:55:50 up  9:06,  2 users,  load average: 0.16, 0.28, 0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:
> 
> > * Christoph Lameter (clameter@sgi.com) wrote:
> > > On Thu, 28 Feb 2008, Mathieu Desnoyers wrote:
> > > 
> > > > In short, the we also use the versioning to check for change of slab.
> 
> Then we do not need the page->end field anymore right? I will try 
> to rediff your patch against current slab-mm and see how we can proceed 
> from there.

I guess you could replace page->end with the (expensive)
page_address(page) + 1 in new_slab.

You would also have to change slab_address() to use
page_address(page). Since this is used by check_valid_pointer, I am not
sure it's a good idea to use this slow operation there.

Or maybe you have a different alternative in mind ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
