Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYKPIQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYKPIQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYKPIQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:16:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39556
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYKPIQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:16:38 -0500
Date: Sun, 16 Nov 2008 00:16:37 -0800 (PST)
Message-Id: <20081116.001637.76266244.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] memcontrol: use simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081116045128.GB24624@x200.localdomain>
References: <491FA2AA.6060706@cn.fujitsu.com>
	<20081116045128.GB24624@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 16 Nov 2008 07:51:28 +0300

> On Sun, Nov 16, 2008 at 12:33:46PM +0800, Lai Jiangshan wrote:
> > use simple_malloc()/simple_free() instead of current codes.
> 
> struct mem_cgroup can't reach the size when kmalloc starts failing.

That's not the point.

When you got past a page, kmalloc/gfp allocations are less reliable,
and people also want NUMA spreading when possible.

That's why we use PAGE_SIZE as the table vmalloc() breakpoint.  We do
this in many places already, with the exact same heuristics, and
for the exact same reasons.
