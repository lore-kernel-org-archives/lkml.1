Return-Path: <linux-kernel-owner+w=401wt.eu-S965920AbXCPUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920AbXCPUzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965921AbXCPUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:55:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44873
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965920AbXCPUzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:55:47 -0400
Date: Fri, 16 Mar 2007 13:55:45 -0700 (PDT)
Message-Id: <20070316.135545.119242282.davem@davemloft.net>
To: clameter@sgi.com
Cc: andi@firstfloor.org, rostedt@goodmis.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, chrisw@sous-sol.org, rusty@rustcorp.com.au,
       glommer@gmail.com
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703161350260.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
	<20070316.134718.95058720.davem@davemloft.net>
	<Pine.LNX.4.64.0703161350260.6204@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 16 Mar 2007 13:52:18 -0700 (PDT)

> Virtual mmap allows holes in the same way as page tables do.

I don't want to take expensive TLB misses to lookup a page.

Don't force a virtual mapping solution down my throat if that
is not what I believe as a platform maintainer works best
for me.

TLB misses are extremely expensive on some platforms, that's why
I try to make all the critical structures go through the 4MB
locked TLB entry for the kernel image, or failing that the
4MB linear mappings at PAGE_OFFSET on sparc64.
