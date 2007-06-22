Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXFVKQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXFVKQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 06:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXFVKQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 06:16:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXFVKQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 06:16:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: NUMA BOF @OLS
Date: Fri, 22 Jun 2007 12:14:58 +0200
User-Agent: KMail/1.9.6
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com> <200706220112.51813.arnd@arndb.de> <Pine.LNX.4.64.0706211844420.11754@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706211844420.11754@schroedinger.engr.sgi.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706221214.58823.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+fbedwjp9PJhrtgHWe0Idw2Szo8Ud94t5r5CO
 LkRe0chvBu7Ry6Pxn523TuQxh7R1hPUzlUnhgVOrtqAPq9GsOY
 GQoOCfEJzCKE1ksbbiuIg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Christoph Lameter wrote:
> 
> On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> 
> > - Interface for preallocating hugetlbfs pages per node instead of system wide
> 
> We may want to get a bit higher level than that. General way of 
> controlling subsystem use on nodes. One wants to restrict the slab 
> allocator and the kernel etc on nodes too.
> 
> How will this interact with the other NUMA policy specifications?

I guess that's what I'd like to discuss at the BOF. I frequently
get requests from users that need to have some interface for it:
Application currently break if they try to use /proc/sys/vm/nr_hugepages
in combination with numactl --membind.

> > - architecture independent in-kernel API for enumerating CPU sockets with
> >   multicore processors (not sure if that's the same as your existing subject).
> 
> Not sure what you mean by this. We already have a topology interface and 
> the scheduler knows about these things.

I'm not referring to user interfaces or scheduling. It's probably not really
a NUMA topic, but we currently use the topology interfaces for enumerating
sockets on systems that are not really NUMA. This includes stuff like
per-socket 
 * cpufreq settings (these have their own logic currently)
 * IOMMU
 * performance counters
 * thermal management
 * local interrupt controller
 * PCI/HT host bridge

If you have a system with multiple CPUs in one socket and either multiple
sockets in one NUMA node or no NUMA at all,  you have no way of properly
enumerating the sockets.  I'd like to discuss what such an interface
would need to look like to be useful for all architectures.

	Arnd <><
