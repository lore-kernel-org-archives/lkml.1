Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXJDMrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXJDMrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbXJDMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:47:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34700 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbXJDMr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:47:29 -0400
Date: Thu, 4 Oct 2007 21:47:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
Message-Id: <20071004214730.6f6ff3ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4704DD88.8030804@cn.fujitsu.com>
References: <200710031346.l93DkWbE028800@harpo.it.uu.se>
	<20071003232509.929160f1.kamezawa.hiroyu@jp.fujitsu.com>
	<4704D4DE.8010805@cn.fujitsu.com>
	<20071004211746.3071b717.kamezawa.hiroyu@jp.fujitsu.com>
	<4704DD88.8030804@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 21:33:12 +0900
Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote::
> > On Thu, 04 Oct 2007 20:56:14 +0900
> > Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> > 
> >> 	stack.ss_sp = addr + pagesize;
> >> 	stack.ss_flags = 0;
> >> 	stack.ss_size = pagesize;
> > Here is bad. 
> > stack,ss_sp = addr;
> > stack.ss_flags = 0;
> > stack.ss_size = pagesize * 2;
> [What the test code want to do]
> addr+pagesize*2 - addr+pagesize	 -> sigaltstack
> addr+pagesize	- addr		 -> protected region
> The code want to catch overflow when esp enter the protected region.
> 
You have to protect the top of *registered* sigaltstack.
The reason of wraparound is %esp will be set to the bottom of sigaltstack
if it is not on sigaltstack area when signaled.
What you have to do is protect the top of registerd sigaltstack.
If %esp is in the range of registerd sigaltstack at SEGV, wraparound
will stop.

Thanks,
-Kame
 
