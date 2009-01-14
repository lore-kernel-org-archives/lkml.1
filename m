Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZANFa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZANFa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZANFaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:30:19 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:39530 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZANFaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:30:17 -0500
Date: Wed, 14 Jan 2009 11:00:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/4] Memory controller soft limit documentation
Message-ID: <20090114053015.GK27129@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain> <20090107184116.18062.8379.sendpatchset@localhost.localdomain> <6599ad830901131745t704428dav6fbf69aa315285b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830901131745t704428dav6fbf69aa315285b1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Menage <menage@google.com> [2009-01-13 17:45:54]:

> On Wed, Jan 7, 2009 at 10:41 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > -7. TODO
> > +7. Soft limits
> > +
> > +Soft limits allow for greater sharing of memory. The idea behind soft limits
> > +is to allow control groups to use as much of the memory as needed, provided
> > +
> > +a. There is no memory contention
> > +b. They do not exceed their hard limit
> > +
> > +When the system detects memory contention (through do_try_to_free_pages(),
> > +while allocating), control groups are pushed back to their soft limits if
> > +possible. If the soft limit of each control group is very high, they are
> > +pushed back as much as possible to make sure that one control group does not
> > +starve the others.
> 
> Can you give an example here of how to implement the following setup:
> 
> - we have a high-priority latency-sensitive server job A and a bunch
> of low-priority batch jobs B, C and D
> 
> - each job *may* need up to 2GB of memory, but generally each tends to
> use <1GB of memory
> 
> - we want to run all four jobs on a 4GB machine
> 
> - we don't want A to ever have to wait for memory to be reclaimed (as
> it's serving latency-sensitive queries), so the kernel should be
> squashing B/C/D down *before* memory actually runs out.
> 
> Is this possible with the proposed hard/soft limit setup? Or do we
> need some additional support for keeping a pool of pre-reserved free
> memory available?

This is a more complex scenario, It sounds like B/C and D should be
hard limited to 2G or another value, depending on how much you want to
pre-reserve for A (all B/C and D should be in the same cgroup). Then
you want to use soft limits within the B/C/D cgroup. You don't want to
hard limit A, but just setup a 2G soft limit for it.

The notion of prioritized jobs and reservation does not exist yet, but
once we support soft limits and overcommit via soft limits, we could
consider looking at what design aspects would help with it.

-- 
	Balbir
