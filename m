Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZAOF2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZAOF2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZAOF2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:28:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40068 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZAOF2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:28:32 -0500
Date: Thu, 15 Jan 2009 14:27:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090115142725.c3ee5dc4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115051717.GH21516@balbir.in.ibm.com>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<20090114135539.GA21516@balbir.in.ibm.com>
	<20090115122416.e15d88a7.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115041750.GE21516@balbir.in.ibm.com>
	<20090115135223.1789e639.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115051717.GH21516@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 10:47:17 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 13:52:23]:

> > I think rmdir() should succeed everywhen "there are no tasks and children".
> > And that can be done.
> >
> 
> All I am saying is that let rmdir() fail if there are tasks or
> children, which I suspect cgroup takes care of. The second thing to do would
> be to add a mem_cgroup_get_hierarchical() and _put_hierarchical() API's so
> that we can get references all the way up to the parents. My concern
> is that not calling res_counter_uncharge() can lead to dangling
> references and bad behaviour.
>  
> > With Paul's suggestion, I'll add wait_queue for rmdir of cgroup.
> > 
> 
> That might be a good idea and also a good idea to maintain the
> hierarchy (since we will walk up when we do uncharge) until we know
> that css reference count is down to 0.
> 
It seems Nishimura started his work in that direction. (see other mail.)
Let's wait a bit.

-Kame

