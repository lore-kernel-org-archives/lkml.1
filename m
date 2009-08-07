Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZHGDW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZHGDW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbZHGDWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:22:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993AbZHGDWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:22:54 -0400
Date: Thu, 6 Aug 2009 23:22:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char *
 strings
In-Reply-To: <4A7B9BB5.3040005@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908062321420.2840@gandalf.stny.rr.com>
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com> <4A7B8149.3070901@cn.fujitsu.com> <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com>
 <4A7B9BB5.3040005@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Aug 2009, Li Zefan wrote:
> > 
> > What protection is this giving us?
> > 
> 
> __field(char *) suggests it should be treated as plain pointer,
> while __field_ext(char *, FILTER_PTR_STR) suggests he's aware it's
> safe to dereference the pointer, for example the case in Frederic's
> blk events.
> 
> In Frederic's initial version, "char *" field will always be
> attached to ptr_str filter function. This is unsafe, because for
> other fields defined as "char *" but not safe to dereference,
> a user still can do this:
> 
> 	# echo 'name == abc' > filter
> 
> Then we'll deref a pointer that can point to unsafe data.
> 
> In this patch, this won't happen, as long as the developer is
> aware that his use of __field_ext(char *) is right.
> 
> Otherwise, he will just use normal __field(char *) and print
> the pointer itself in TP_printk().

Ah, so the answer I'm looking for is:

The filtering will not dereference "char *" unless the developer 
explicitly sets FILTER_PTR_STR in __field_ext.

Is this above statement correct?

-- Steve

