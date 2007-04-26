Return-Path: <linux-kernel-owner+w=401wt.eu-S1423011AbXDZAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423011AbXDZAav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423015AbXDZAav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:30:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53613 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423011AbXDZAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:30:50 -0400
Date: Thu, 26 Apr 2007 09:31:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, y-goto@jp.fujitsu.com
Subject: Re: [RFC][PATCH] syctl for selecting global zonelist[] order
Message-Id: <20070426093112.ec2ecb00.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704251211070.17886@schroedinger.engr.sgi.com>
References: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0704251211070.17886@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 12:17:15 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 25 Apr 2007, KAMEZAWA Hiroyuki wrote:
> 
> > Make zonelist policy selectable from sysctl.
> > 
> > Assume 2 node NUMA, only node(0) has ZONE_DMA (ZONE_DMA32).
> > 
> > In this case, default (node0's) zonelist order is
> > 
> > Node(0)'s NORMAL -> Node(0)'s DMA -> Node(1)"s NORMAL.
> > 
> > This means Node(0)'s DMA is used before Node(1)'s NORMAL.
> 
> So a IA64 platform with i386 sicknesses? And pretty bad case of it since I 
> assume that the memory sizes per node are equal. Your solution of taking 
> 4G off node 0 and then going to node 1 first must hurt some 
> processes running on node 0. 
I think so, too. It is because I made this as selectable option.

> Whatever you do the  memory balance between the two nodes is making
> the system behave in an unsymmetric way.


> > In some server, some application uses large memory allcation.
> > This exhaust memory in the above order.
> 
> Could we add a boot time option instead that changes the zonelist build 
> behavior? Maybe an arch hook that can deal with it?
> 
Yes, it' in my plan. I'll add boot option support.

Thanks,
-Kame

