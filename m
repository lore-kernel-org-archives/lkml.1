Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZIUUlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZIUUlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZIUUlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:41:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbZIUUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:41:08 -0400
Date: Mon, 21 Sep 2009 13:41:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: dump stack and VM state when oom killer panics
Message-Id: <20090921134104.79668479.akpm@linux-foundation.org>
In-Reply-To: <20090918092427.8E48.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.1.00.0909171354570.17483@chino.kir.corp.google.com>
	<20090918092427.8E48.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 09:26:37 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hello
> 
> > The oom killer header, including information such as the allocation order
> > and gfp mask, current's cpuset and memory controller, call trace, and VM
> > state information is currently only shown when the oom killer has
> > selected a task to kill.
> > 
> > This information is omitted, however, when the oom killer panics either
> > because of panic_on_oom sysctl settings or when no killable task was
> > found.  It is still relevant to know crucial pieces of information such
> > as the allocation order and VM state when diagnosing such issues,
> > especially at boot.
> > 
> > This patch displays the oom killer header whenever it panics so that bug
> > reports can include pertinent information to debug the issue, if
> > possible.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Good patch :)
> 
> I have one request. In panic case, I don't hope to call printk_ratelimit().
> the infomation should be displayed always.
> 

The code shouldn't be using printk_ratelimit() - in fact nothing should
be using it and we should remove printk_ratelimit() from the kernel, I
suspect.

Because it uses global state, so a printk_ratelimit() in some random
net driver could cause printks from the oom-killer to be suppressed.

Switching to __ratelimit() would fix such interactions.
