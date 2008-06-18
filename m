Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYFREmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYFREmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYFREmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:42:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45293 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYFREmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:42:42 -0400
Date: Wed, 18 Jun 2008 13:41:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in
 2.6.26-rc5-mm3
Message-Id: <20080618134128.828156bc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080618105400.b9f1b664.nishimura@mxp.nes.nec.co.jp>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
	<20080618003129.DE27.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080618105400.b9f1b664.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 10:54:00 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> On Wed, 18 Jun 2008 00:33:18 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > @@ -715,13 +725,7 @@ unlock:
> > >   		 * restored.
> > >   		 */
> > >   		list_del(&page->lru);
> > > -		if (!page->mapping) {
> > > -			VM_BUG_ON(page_count(page) != 1);
> > > -			unlock_page(page);
> > > -			put_page(page);		/* just free the old page */
> > > -			goto end_migration;
> > > -		} else
> > > -			unlock = putback_lru_page(page);
> > > +		unlock = putback_lru_page(page);
> > >  	}
> > >  
> > >  	if (unlock)
> > 
> > this part is really necessary?
> > I tryed to remove it, but any problem doesn't happend.
> > 
> I made this part first, and added a fix for migration_entry_wait later.
> 
> So, I haven't test without this part, and I think it will cause
> VM_BUG_ON() here without this part.
> 
> Anyway, I will test it.
> 
I got this VM_BUG_ON() as expected only by doing:

  # echo $$ >/cgroup/cpuset/02/tasks

So, I beleive that both fixes for migration_entry_wait and
unmap_and_move (and, of course, removal VM_BUG_ON from
putback_lru_page) are needed.


Thanks,
Daisuke Nishimura.
