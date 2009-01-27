Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZA0Hoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZA0Hoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZA0Hop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:44:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34145 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0Hop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:44:45 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Cc: kosaki.motohiro@jp.fujitsu.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       balbir@linux.vnet.ibm.com, Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Linus@smtp1.linux-foundation.org,
       Paul Menage <menage@google.com>
In-Reply-To: <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com>
Message-Id: <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 16:44:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Jan 2009, KOSAKI Motohiro wrote:
> 
> > Confused.
> > 
> > As far as I know, people want the method of flexible cache treating.
> > but oom seems less flexible than userland notification.
> > 
> > Why do you think notification is bad?
> > 
> 
> There're a couple of proposals that have been discussed recently that 
> share some functional behavior.
> 
> One is the cgroup oom notifier that allows you to attach a task to wait on 
> an oom condition for a collection of tasks.  That allows userspace to 
> respond to the condition by droping caches, adding nodes to a cpuset, 
> elevating memory controller limits, sending a signal, etc.  It can also 
> defer to the kernel oom killer as a last resort.
> 
> The other is /dev/mem_notify that allows you to poll() on a device file 
> and be informed of low memory events.  This can include the cgroup oom 
> notifier behavior when a collection of tasks is completely out of memory, 
> but can also warn when such a condition may be imminent.  I suggested that 
> this be implemented as a client of cgroups so that different handlers can 
> be responsible for different aggregates of tasks.
>
> I think the latter is a much more powerful tool and includes all the 
> behavior of the former.  It preserves the oom killer as a last resort for 
> the kernel and defers all preference killing or lowmem responses to 
> userspace.

Yup, indeed. :)
honestly, I talked about the same thingk recently "lowmemory android driver not needed?" thread.



