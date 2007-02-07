Return-Path: <linux-kernel-owner+w=401wt.eu-S1161141AbXBGKiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141AbXBGKiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161164AbXBGKiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:38:02 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32775 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161141AbXBGKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:38:00 -0500
Date: Wed, 7 Feb 2007 19:37:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207193749.fa58632e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200702071119.03125.ak@suse.de>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
	<20070207190738.30f1d419.kamezawa.hiroyu@jp.fujitsu.com>
	<200702071119.03125.ak@suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 11:19:02 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> > AFAIK, ia64 creates nodes just depends on SRAT's possible resource information.
> > Then, ia64 can create cpu-memory-less-node(node with no available resource.).
> > (*)I don't like this.
> > 
> > If we don't allow memory-less-node, we may have to add several codes for cpu-hot-add.
> > cpus should be moved to nearby node at hotadd .
> > And node-hot-add have to care that cpus mustn't be added before memory, cpu-driven 
> > node-hot-add will never occur. (ACPI's 'container' device spec can't guaranntee this.)
> 
> You can also alias node numbers to solve this: just point multiple node numbers 
> to the same pgdat. For a memory less node this would be a nearby one.
> 
Hmm, interesting...the 'alias' means follwing ?
==
NODE_DATA(A) = pgdat_for_A
NODE_DATA(B) = pgdat_for_A // B is memory-less.
- NODE_DATA(B) is valid but B is not online.
==
looks complicated..and we have to care /sys/devices/system/node handling.

-Kame

