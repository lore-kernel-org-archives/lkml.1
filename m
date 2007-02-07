Return-Path: <linux-kernel-owner+w=401wt.eu-S1030507AbXBGIhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030507AbXBGIhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXBGIhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:37:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030507AbXBGIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:37:01 -0500
Date: Wed, 7 Feb 2007 17:36:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org, linux-ia64@vger.kernel.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207173647.86bd64c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702070002430.2188@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
	<20070207101400.feda1bf9.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702070002430.2188@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 00:04:41 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 7 Feb 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > Hmmm... Remove the node from the node_online_map instead?
> > > 
> > Changing defintion of node_online_map is harmfil. (there are cpu-only-nodes.)
> > How about adding  nodemask for nodes equips memory ?
> 
> Ok that is better but...
> 
> Would it be possible to attach the cpus to the 
> next nodes with memory and mark the node offline? That way we could avoid 
> another mask that we constantly have to check?
> 
Added ia64 list to CC.
I know ia64 kernel did what you say in old days (I know RHEL4/2.6.9 kernel does it).
Someone changed it and created cpu-only-node for some purpose, I don't know why.


> Or fix the location where the error occurred to be able to tolerate a node 
> with no zones?
> 
Hmm, 
In this case, MPOL_MBIND, the user requests to allocate memory from specified nodes.
I think it's better to tell him "you can't do that" than silently allocating memory
from other places.

-Kame





