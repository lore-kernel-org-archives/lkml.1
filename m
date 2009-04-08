Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZDHDRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZDHDRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZDHDRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:17:41 -0400
Received: from ozlabs.org ([203.10.76.45]:37119 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZDHDRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:17:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Date: Wed, 8 Apr 2009 12:47:08 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904071356.29914.rusty@rustcorp.com.au> <1239087953.798.5513.camel@twins>
In-Reply-To: <1239087953.798.5513.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081247.08712.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009 16:35:53 Peter Zijlstra wrote:
> On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> > Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> > patch which I just put out the pull request for.
> 
> Would it make sense to teach it about a short-circuit like:
> 
> work_on_cpu() {
> 
>   if (cpumask_weight(current->cpus_allowed) == 1 && 
>       smp_processor_id() == cpu)
>     return do_work_right_here();

Does that happen much?  I guess put a counter in and see?

Rusty.
