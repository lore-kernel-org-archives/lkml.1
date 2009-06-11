Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZFKOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZFKOjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZFKOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:39:38 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:43672 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZFKOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:39:37 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A311727.40403@lwfinger.net>
Date: Thu, 11 Jun 2009 09:39:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>	 <alpine.DEB.1.10.0906110941520.29827@gentwo.org> <1244728824.17483.51.camel@penberg-laptop>
In-Reply-To: <1244728824.17483.51.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Christoph,
> 
> On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
>> We have had that with SLAB. NO! This leads to the situation that some
>> slabs have debug on and some have not. You just do not know which.
> 
> I do see your point but surely we don't want to use order 1 allocations
> in the fall-back case for kmalloc-4096? Couldn't we just add a printk
> saying that debug was disabled for the cache? After all, my patch is
> much better than what SLAB does.
> 
> On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
>> Note that CONFIG_SLUB_DEBUG only enables the code to debug a slab. It does
>> not enable debugging for each slab. CONFIG_SLUB_DEBUG_ON does that.
> 
> True. Larry, do you have CONFIG_SLUB_DEBUG_ON enabled or are you passing
> SLUB debugging options to the kernel?

It is enabled in the kernel. My SLUB options in .config are:

finger@larrylap:~> grep SLUB .config
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set

Would having STATS enabled help?

For a bug that hits infrequently, determining that it is fixed is
difficult. That said, my system has been up about 22.5 hours during
which I have tried to force the failure. I see the fragmentation of
memory vary widely as shown below:

finger@larrylap:~> date ; cat /proc/buddyinfo
Wed Jun 10 20:15:34 CDT 2009
Node 0, zone      DMA      4      3      5      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32   5920  11678   2245    369    117     21      2
     1      0      0      0
finger@larrylap:~> date ; cat /proc/buddyinfo
Wed Jun 10 23:32:39 CDT 2009
Node 0, zone      DMA      4      3      5      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32   2605   4140   3804      7      0      1      1
     1      0      0      0
finger@larrylap:~> date ; cat /proc/buddyinfo
Thu Jun 11 09:28:06 CDT 2009
Node 0, zone      DMA      4      3      5      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32   2231    429   2726     54      1      0      1
     1      0      0      0
finger@larrylap:~> cat /proc/uptime
80678.11 78.54

The latest value of the number of O(1) fragments is about as low as I
have seen.

Larry
