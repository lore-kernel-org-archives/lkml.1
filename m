Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZG1BDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZG1BDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG1BDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:03:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZG1BDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:03:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cU7oBOVnEbuT0jvtdnd+Gal4NZ7AVBH4/jWTnBmLZMT+UmqdBcOGbIv2nehxXlhJW
	uZSRzHUDm9WAUKj0+z9pg==
Date: Mon, 27 Jul 2009 18:02:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       y-goto@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <20090728095453.1fe79de1.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907271758170.29815@chino.kir.corp.google.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com> <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com> <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
 <20090724160936.a3b8ad29.akpm@linux-foundation.org> <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com> <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com> <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
 <alpine.DEB.2.00.0907271047590.8408@chino.kir.corp.google.com> <20090728085810.f7ae678a.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907271710590.27881@chino.kir.corp.google.com> <20090728092529.bb0d7e9c.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0907271731040.29815@chino.kir.corp.google.com> <20090728095453.1fe79de1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, KAMEZAWA Hiroyuki wrote:

> > The problem originally reported here doesn't appear to have anything to do 
> > with hotplug, it looks like it is the result of Lee's observation that 
> > ia64 defaults top_cpuset's mems to N_POSSIBLE, which _should_ have been 
> > updated by cpuset_init_smp(). 
> cpuset_init_smp() just updates cpuset's mask.
> init's task->mems_allowed is intizialized independently from cpuset's mask.
> 

Presumably the bug is that N_HIGH_MEMORY is not a subset of N_ONLINE at 
this point on ia64.

> Could you teach me a pointer for Lee's observation ?
> 

http://marc.info/?l=linux-kernel&m=124767909310293
