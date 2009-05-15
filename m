Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZEOIJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZEOIJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZEOIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:08:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56354 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZEOIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:08:52 -0400
Subject: Re: kernel BUG at mm/slqb.c:1411!
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       matthew.r.wilcox@intel.com
In-Reply-To: <20090515083726.F5BF.A69D9226@jp.fujitsu.com>
References: <1242289830.21646.5.camel@penberg-laptop>
	 <20090514175332.9B7B.A69D9226@jp.fujitsu.com>
	 <20090515083726.F5BF.A69D9226@jp.fujitsu.com>
Date: Fri, 15 May 2009 11:08:51 +0300
Message-Id: <1242374931.21646.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Motohiro-san,

On Wed, 2009-05-13 at 17:37 +0900, Minchan Kim wrote:
> > > > On Wed, 13 May 2009 16:42:37 +0900 (JST)
> > > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > 
> > > > Hmm. I don't know slqb well.
> > > > So, It's just my guess. 
> > > > 
> > > > We surely increase l->nr_partial in  __slab_alloc_page.
> > > > In between l->nr_partial++ and call __cache_list_get_page, Who is decrease l->nr_partial again.
> > > > After all, __cache_list_get_page return NULL and hit the VM_BUG_ON.
> > > > 
> > > > Comment said :
> > > > 
> > > >         /* Protects nr_partial, nr_slabs, and partial */
> > > >   spinlock_t    page_lock;
> > > > 
> > > > As comment is right, We have to hold the l->page_lock ?
> > > 
> > > Makes sense. Nick? Motohiro-san, can you try this patch please?
> > 
> > This issue is very rarely. please give me one night.

On Fri, 2009-05-15 at 08:38 +0900, KOSAKI Motohiro wrote:
> -ENOTREPRODUCED
> 
> I guess your patch is right fix. thanks!

Thank you so much for testing!

Nick seems to have gone silent for the past few days so I went ahead and
merged the patch.

Did you have CONFIG_PROVE_LOCKING enabled, btw? I think I got the lock
order correct but I don't have a NUMA machine to test it with here.

			Pekka

