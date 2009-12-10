Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbZLJXqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbZLJXqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbZLJXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:46:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34969 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbZLJXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:46:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: lwoodman@redhat.com
Subject: Re: [RFC][PATCH v2  4/8] Replace page_referenced() with wipe_page_reference()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <4B20EF88.7050402@redhat.com>
References: <20091210163123.255C.A69D9226@jp.fujitsu.com> <4B20EF88.7050402@redhat.com>
Message-Id: <20091211082410.257D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 11 Dec 2009 08:46:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > @@ -578,7 +577,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >
> > +		struct page_reference_context refctx = {
> > +			.is_page_locked = 1,
> >
> >   *
> > @@ -1289,7 +1291,6 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> >
> > +		struct page_reference_context refctx = {
> > +			.is_page_locked = 0,
> > +		};
> > +
> >   
> are these whole structs properly initialized on the kernel stack?

Yes. C spec says

3.5.7 Initialization

Syntax

          initializer:
                  assignment-expression
                  {  initializer-list } 
                  {  initializer-list , }

          initializer-list:
                  initializer
                  initializer-list ,  initializer
(snip)

   If there are fewer initializers in a list than there are members of
an aggregate, the remainder of the aggregate shall be initialized
implicitly the same as objects that have static storage duration.

Referenced to
  Draft ANSI C Standard (ANSI X3J11/88-090) (May 13, 1988) http://flash-gordon.me.uk/ansi.c.txt


Probably, google "{0}" help your understand to initializer in C.




