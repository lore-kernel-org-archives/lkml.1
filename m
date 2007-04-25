Return-Path: <linux-kernel-owner+w=401wt.eu-S2992972AbXDYTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992972AbXDYTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992971AbXDYTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:17:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33822 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992963AbXDYTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:17:17 -0400
Date: Wed, 25 Apr 2007 12:17:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] syctl for selecting global zonelist[] order
In-Reply-To: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704251211070.17886@schroedinger.engr.sgi.com>
References: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, KAMEZAWA Hiroyuki wrote:

> Make zonelist policy selectable from sysctl.
> 
> Assume 2 node NUMA, only node(0) has ZONE_DMA (ZONE_DMA32).
> 
> In this case, default (node0's) zonelist order is
> 
> Node(0)'s NORMAL -> Node(0)'s DMA -> Node(1)"s NORMAL.
> 
> This means Node(0)'s DMA is used before Node(1)'s NORMAL.

So a IA64 platform with i386 sicknesses? And pretty bad case of it since I 
assume that the memory sizes per node are equal. Your solution of taking 
4G off node 0 and then going to node 1 first must hurt some 
processes running on node 0. But there is no easy solution since 
the hardware is badly screwed up with 32 bit I/O. Whatever you do the 
memory balance between the two nodes is making the system behave in
an unsymmetric way.

> In some server, some application uses large memory allcation.
> This exhaust memory in the above order.

Could we add a boot time option instead that changes the zonelist build 
behavior? Maybe an arch hook that can deal with it?
