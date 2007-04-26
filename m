Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXDZPsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXDZPsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031193AbXDZPsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:48:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42550 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030682AbXDZPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:48:20 -0400
Date: Thu, 26 Apr 2007 08:48:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] change global zonelist order on NUMA v2
In-Reply-To: <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
 <200704261147.44413.ak@suse.de> <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, KAMEZAWA Hiroyuki wrote:

> (1)Use new zonelist ordering always and move init_task's tied cpu to a
>   cpu on the best node. 
>   Child processes will start in good nodes even if Node 0 has small memory.

How about renumbering the nodes? Node 0 is the one with no DMA memory and 
node 1 may be the one with the DMA? That would take care of things even 
without core modifications. We can start on node 0 (which hardware 1) and 
consume the required memory for boot there not impacting the node with the 
DMA memory.


