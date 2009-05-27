Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZE0CrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZE0CrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZE0CrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:47:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZE0CrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:47:09 -0400
Date: Tue, 26 May 2009 22:47:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
In-Reply-To: <4A1CA68B.4070609@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905262244580.27902@gandalf.stny.rr.com>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com> <4A1C9645.7010107@cn.fujitsu.com> <alpine.DEB.2.00.0905262147470.27902@gandalf.stny.rr.com> <4A1C9E70.8000609@cn.fujitsu.com>
 <alpine.DEB.2.00.0905262202390.27902@gandalf.stny.rr.com> <4A1CA68B.4070609@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 May 2009, Li Zefan wrote:
> Yeah, it does look somewhat ugly..
> 
> > Could we instead perhaps add a __dynamic_array? That would take a length, 
> > and append itself to after the strings?
> > 
> 
> I thought about this actually. ;)
> 
> What troubled me is to give this new macro a better name.
> 
> We have __array() which is fixed-size, but __dynamic_array() is not
> a dynamic-size version of __array(). How about __dyn_string() or
> __dynamic_string()?

String in many languages are non fixed size. But why not call it a dynamic 
array. We can make it into a varible length array. But the assignment may 
need to be careful.

> 
> > stage 1:
> > 
> > #define __dynamic_array(item, len)	int __dyn_loc_##item;
> > 
> > stage 2:
> > 
> > #define __dynamic_array(item, len)	int item;
> > 
> > stage 3:
> > 
> > #define __get_dynamic_array(item)	\
> > 	((void *)__entry + __entry->__str_loc_##field
> > 
> > stage 4:
> > 
> > #define __dynamic_array(item, len)	\
> > 	__str_offsets.item = __str_size + \
> > 		offsetof(typeof(*entry), __str_data);	\
> > 	__str_size += len;
> > 
> 
> Then we can make __string() reuse __dynamic_array().

Yeah, the __string() can end up being a wrapper around a __dynamic_array 
macro that just adds the strlen().

-- Steve

