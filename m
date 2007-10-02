Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXJCL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXJCL5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXJCL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:57:06 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:46955 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755713AbXJCL5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:57:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=04YPpZpBwDZKi2CT6/tj5fs4+/UpFRipBmifWN7aFj3KMS2E0Wb8VfqycnmsqaGlNxskscIukWTvUXtuH6eyjUiIuIekxEELdYSokTYJkOV3xxd1eVTBhjMGP+tiBwhqBfHHg9g+yuOpCxDHjfUiIXLAfigrvK6AxAaYbni4Sq4=  ;
X-YMail-OSG: AZ1vVdgVM1n8u0fu9SIZZo5Zk109nduiOGc6Dq0kQTWc0BIFEyONmxabfromSQUaym2tDHZNCA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 05:25:29 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030356.18090.nickpiggin@yahoo.com.au> <20071003043818.baa0e1ce.pj@sgi.com>
In-Reply-To: <20071003043818.baa0e1ce.pj@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710030525.29735.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 21:38, Paul Jackson wrote:
> > OK, so to really do anything different (from a non-partitioned setup),
> > you would need to set sched_load_balance=0 for the root cpuset?

> > Suppose you do that to hard partition the machine, what happens to
> > newly created tasks like kernel threads or things that aren't in a
> > cpuset?
>
> Well ... --every-- task is in a cpuset, always.  Newly created tasks
> start in the cpuset of their parent.  Grep for 'the_top_cpuset_hack'
> in kernel/cpuset.c to see the lengths to which we go to ensure that
> current->cpuset always resolves somewhere.

OK, then non-balancing cpuset.


> The usual case on the big systems that I care about the most is
> that we move (almost) every task out of the top cpuset, into smaller
> cpusets, because we don't want some random thread intruding on the
> CPUs dedicated to a particular job.  The only threads left in the root
> cpuset are pinned kernel threads, such as for thread migration, per-cpu
> irq handlers and various per-cpu and per-node disk and file flushers
> and such.  These threads aren't going anywhere, regardless.  But no
> thread that is willing to run anywhere is left free to run anywhere.

These are what I'm worried about, and things like kswapd, pdflush,
could definitely use a huge amount of CPU.

If you are interested in hard partitioning the system, you most
definitely want these things to be balanced across the non-isolated
CPUs.

