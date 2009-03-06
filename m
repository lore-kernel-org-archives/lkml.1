Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZCFJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZCFJJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbZCFJJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:09:07 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50450 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZCFJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:09:06 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090306085731.GA4225@x200.localdomain>
References: <20090306003900.a031a914.akpm@linux-foundation.org> <20090306085731.GA4225@x200.localdomain>
Message-Id: <20090306180559.9BD9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri,  6 Mar 2009 18:09:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Mar 06, 2009 at 12:39:00AM -0800, Andrew Morton wrote:
> > On Fri, 06 Mar 2009 16:27:53 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > > Let's not add wrapper for every two lines that happen to be used
> > > > together.
> > > > 
> > > 
> > > Why not if we have good reasons? And I don't think we can call this
> > > "happen to" if there are 250+ of them?
> > 
> > The change is a good one.  If a reviewer (me) sees it then you know the
> > code's all right and the review effort becomes less - all you need to check
> > is that the call site is using IS_ERR/PTR_ERR and isn't testing for
> > NULL.  Less code, less chance for bugs.
> > 
> > Plus it makes kernel text smaller.
> > 
> > Yes, the name is a bit cumbersome.
> 
> Some do NUL-termination afterwards and allocate "len + 1", but copy "len".
> Some don't care.

if subsystem want string data, it should use strndup_user().
memdump don't need to care NUL-termination

In addition, also I often review various mm code and patch, I also like
this change.



