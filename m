Return-Path: <linux-kernel-owner+w=401wt.eu-S1422983AbXBHIQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422983AbXBHIQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161551AbXBHIQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:16:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60099 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161481AbXBHIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:16:32 -0500
Date: Thu, 8 Feb 2007 17:16:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, akpm@osdl.org,
       y-goto@jp.fujitsu.com
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take2
Message-Id: <20070208171610.d1bea5d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200702080849.42167.ak@suse.de>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
	<200702080849.42167.ak@suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 08:49:41 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> > This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> > node(2) was memory-less-node.
> 
> I still think it's the wrong fix -- just get rid of the memory less node.
> I expect you'll likely run into more problems with that setup anyways.
> 
memory-less-node problem is a bit big issue for this small bug.

For removing memory-less-node, we'll have to make consensus on 
"a node represents a group of memory, not cpu, not devices"

I read old e-mails on node-hotplug again.
In the early stage of node-hotplug, I assumes "a node has memory".
After discussion between several groups, I knew there are people
who consider groups of something as node.
(and we had to change our plan......)
like this (old) homepage's FAQ 5. http://lse.sourceforge.net/numa/faq/


> >  static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
> >  {
> >  	struct mempolicy *policy;
> > +	void  *val;
> 
> Using void * here is nasty when it's a zonelist pointer.
> 
okay. changes this to be more neat one..take3 will come.

-Kame




