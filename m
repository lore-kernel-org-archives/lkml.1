Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbXJCNDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbXJCNDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXJCNDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:03:34 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:43029 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751968AbXJCNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:03:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JyaVayhWv+PyBSOHk8L5AAoSO24x4TMUd8iRyROVEXG76iXfU/+1EnazHoxI6rCubyo39w+YVKPUYNtc36KA7oZ0R8w440AT12joGgj5b3lGZdtaC5jzO8o0yVBVKShyeLu11/l5NFt5D7huZ2X+ecuLez1+RhYCI+iXiWRU1vg=  ;
X-YMail-OSG: P3fsQ5kVM1kXjhD00YfbLXISAUD3aEO4haLPZUKYXjyy08Fijwy7e5EBKerWxMRC3wKGs8PRcA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 06:31:59 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030356.18090.nickpiggin@yahoo.com.au> <20071003051729.df3d8ab9.pj@sgi.com>
In-Reply-To: <20071003051729.df3d8ab9.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030632.00062.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 22:17, Paul Jackson wrote:
> Nick wrote:
> > OK, so I don't exactly understand you either. To make it simple, can
> > you give a concrete example of a cpuset hierarchy that wouldn't
> > work?
>
> It's more a matter of knowing how my third party batch scheduler
> coders think.  They will be off in some corner of their code with a
> cpuset in hand that they know is just being used to hold inactive
> (paused) tasks, and they can likely be persuaded to mark those cpusets
> as not being in need of any wasted CPU cycles load balancing them.

There won't be any CPU cycles used, if the tasks are paused (surely
they're not spin waiting).


> But these inactive cpusets will overlap in unknown (to them at
> the time, in that piece of code) ways with other cpusets holding
> active jobs, and there is no chance, unless it is a matter of major
> performance impact, that they will be in any position to comment on
> the proper partitioning of the sched domains on all the CPUs under the
> control of their batch scheduler, much less comment on the partitioning
> of the rest of the system.
