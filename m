Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXBGKt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXBGKt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXBGKt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:49:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38529 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXBGKtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:49:55 -0500
Date: Wed, 7 Feb 2007 19:49:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207194909.658aa454.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200702071141.25990.ak@suse.de>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<200702071119.03125.ak@suse.de>
	<20070207193749.fa58632e.kamezawa.hiroyu@jp.fujitsu.com>
	<200702071141.25990.ak@suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 11:41:25 +0100
Andi Kleen <ak@suse.de> wrote:

> On Wednesday 07 February 2007 11:37, KAMEZAWA Hiroyuki wrote:
> > On Wed, 7 Feb 2007 11:19:02 +0100
> > Andi Kleen <ak@suse.de> wrote:
> > > You can also alias node numbers to solve this: just point multiple node numbers 
> > > to the same pgdat. For a memory less node this would be a nearby one.
> > > 
> > Hmm, interesting...the 'alias' means follwing ?
> 
> Yes.
> 
> > NODE_DATA(A) = pgdat_for_A
> > NODE_DATA(B) = pgdat_for_A // B is memory-less.
> > - NODE_DATA(B) is valid but B is not online.
> 
> Well it is online because A is. For all practical purposes
> it is A, just under a different name.
> 
> > ==
> > looks complicated..and we have to care /sys/devices/system/node handling.
> 
> x86-64 used to do that when it still only did 1:1 cpu<->memory mappings.
> I don't remember any problems with it.
> 

How for_each_online_node(nid) works ? it can handle alias-nid ?

==
	for_each_online_node(nid) {
		pgdat = NODE_DATA(nid);
==
This code never accesses pgdat_for_A twice ?

Thanks,
-Kame


