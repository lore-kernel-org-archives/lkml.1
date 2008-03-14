Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYCNWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYCNWXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYCNWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:23:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYCNWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:23:27 -0400
Message-ID: <47DAFAA2.20302@redhat.com>
Date: Fri, 14 Mar 2008 18:22:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
Subject: Re: [PATCH -mm 1/5] list.h: add list_singleton
References: <47DAE2C4.2060303@redhat.com> <20080314140007.a7b495d7.akpm@linux-foundation.org>
In-Reply-To: <20080314140007.a7b495d7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> If your usage pattern is:
> 
> struct foo {
> 	...
> 	struct list_head bar_list;	/* A list of `struct bar's */
> };
> 
> struct bar {
> 	struct list_head list;		/* Attached to foo.bar_list */
> 	...
> };
> 
> then yes, list_singleton() makes sense.
> 
> But in other usage patterns it does not:
> 
> struct foo {
> 	struct bar *bar_list;
> 	...
> };
> 
> struct bar {
> 	struct list_head list;		/* All the other bars go here */
> 	...
> };
> 
> In the second case, emptiness is signified by foo.bar_list==NULL.  And in
> this case, code which does
> 
> 	if (foo->bar_list && list_singleton(&foo->bar_list->list))
> 
> will fail if there is a single item on the list!
> 
> The second usage pattern is uncommon and list_empty() also returns
> misleading answers when list_heads are used this way.

I agreed. I assume that list_singleton() is used like as list_empty().


> So I guess we can proceed with your list_singleton(), but I'd just like to
> flag this possible confusion, see what people think..

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

