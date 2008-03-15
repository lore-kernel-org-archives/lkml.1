Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYCOWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYCOWhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYCOWhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:37:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50233 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYCOWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:37:33 -0400
Subject: Re: [PATCH -mm 1/5] list.h: add list_singleton
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, prasanna@in.ibm.com, shaohua.li@intel.com,
       davem@davemloft.net, fche@redhat.com
In-Reply-To: <47DAFAA2.20302@redhat.com>
References: <47DAE2C4.2060303@redhat.com>
	 <20080314140007.a7b495d7.akpm@linux-foundation.org>
	 <47DAFAA2.20302@redhat.com>
Content-Type: text/plain
Date: Sat, 15 Mar 2008 23:36:36 +0100
Message-Id: <1205620596.6422.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 18:22 -0400, Masami Hiramatsu wrote:
> Andrew Morton wrote:
> > If your usage pattern is:
> > 
> > struct foo {
> > 	...
> > 	struct list_head bar_list;	/* A list of `struct bar's */
> > };
> > 
> > struct bar {
> > 	struct list_head list;		/* Attached to foo.bar_list */
> > 	...
> > };
> > 
> > then yes, list_singleton() makes sense.
> > 
> > But in other usage patterns it does not:
> > 
> > struct foo {
> > 	struct bar *bar_list;
> > 	...
> > };
> > 
> > struct bar {
> > 	struct list_head list;		/* All the other bars go here */
> > 	...
> > };
> > 
> > In the second case, emptiness is signified by foo.bar_list==NULL.  And in
> > this case, code which does
> > 
> > 	if (foo->bar_list && list_singleton(&foo->bar_list->list))
> > 
> > will fail if there is a single item on the list!
> > 
> > The second usage pattern is uncommon and list_empty() also returns
> > misleading answers when list_heads are used this way.
> 
> I agreed. I assume that list_singleton() is used like as list_empty().
> 
> 
> > So I guess we can proceed with your list_singleton(), but I'd just like to
> > flag this possible confusion, see what people think..

May I kindly ask to please not use the singleton name like this. It does
not implement the singleton pattern and will be a great confusion for
everybody who expects it to.


