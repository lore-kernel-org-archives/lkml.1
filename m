Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZENIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZENIyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZENIyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:54:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44277 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZENIyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:54:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: kernel BUG at mm/slqb.c:1411!
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1242289830.21646.5.camel@penberg-laptop>
References: <20090513173758.2f3d2a50.minchan.kim@barrios-desktop> <1242289830.21646.5.camel@penberg-laptop>
Message-Id: <20090514175332.9B7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 17:54:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-05-13 at 17:37 +0900, Minchan Kim wrote:
> > On Wed, 13 May 2009 16:42:37 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > Hmm. I don't know slqb well.
> > So, It's just my guess. 
> > 
> > We surely increase l->nr_partial in  __slab_alloc_page.
> > In between l->nr_partial++ and call __cache_list_get_page, Who is decrease l->nr_partial again.
> > After all, __cache_list_get_page return NULL and hit the VM_BUG_ON.
> > 
> > Comment said :
> > 
> >         /* Protects nr_partial, nr_slabs, and partial */
> >   spinlock_t    page_lock;
> > 
> > As comment is right, We have to hold the l->page_lock ?
> 
> Makes sense. Nick? Motohiro-san, can you try this patch please?

This issue is very rarely. please give me one night.



