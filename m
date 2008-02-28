Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbYB1UYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbYB1UYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbYB1UYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:24:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760627AbYB1UYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:24:16 -0500
Date: Thu, 28 Feb 2008 15:23:56 -0500
From: Rik van Riel <riel@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: Re: [patch 00/21] VM pageout scalability improvements
Message-ID: <20080228152356.0fc8178f@bree.surriel.com>
In-Reply-To: <18375.5642.424239.215806@stoffel.org>
References: <20080228192908.126720629@redhat.com>
	<18375.5642.424239.215806@stoffel.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:14:02 -0500
"John Stoffel" <john@stoffel.org> wrote:

> Nitpicky, but what is a large memory system?  I read your web page and
> you talk about large memory being greater than several Gb, and about
> huge systems (> 128gb).  So which is this patch addressing?  
> 
> I ask because I've got a new system with 4Gb of RAM and my motherboard
> can goto 8Gb.  Should this be a large memory system or not?  I've also
> only got a single dual core CPU, how does that affect things?

It depends a lot on the workload.

On a few workloads, the current VM explodes with as little as
16GB of RAM, while a few other workloads the current VM works
fine with 128GB of RAM.

This patch tries to address the behaviour of the kernel when
faced with workloads that trip up the current VM.

> You talk about the Inactive list in the Anonymous memory section, and
> about limiting it.  You say 30% on a 1Gb system, but 1% on a 1Tb
> system, which is interesting numbers but it's not clear where they
> come from.

They seemed a reasonable balance between limiting the maximum amount
of work the VM needs to do and allowing pages the time to get referenced
again.  If benchmarks suggest that the ratio should be tweaked, we can 
do so quite easily.

> I dunno... I honestly don't have the time or the knowledge to do more
> than poke sticks into things and see what happens.  And to ask
> annoying questions.  

Patch series like this can always use a good poking.  Especially by
people who run all kinds of nasty programs to trip up the VM :)

-- 
All rights reversed.
