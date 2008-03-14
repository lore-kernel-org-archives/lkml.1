Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYCNBvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYCNBvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYCNBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:51:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35256 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYCNBva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:51:30 -0400
Date: Fri, 14 Mar 2008 10:55:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Message-Id: <20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	<20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 18:35:51 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Thu, Mar 13, 2008 at 6:34 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 13 Mar 2008 16:45:42 -0700
> >  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >  > int __init reserve_bootmem(unsigned long addr, unsigned long size,
> >  >                           int flags)
> >  >  {
> >  > -     return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
> >  > +     int ret;
> >  > +     bootmem_data_t *bdata;
> >  > +     list_for_each_entry(bdata, &bdata_list, list) {
> >  > +             ret = can_reserve_bootmem_core(bdata, addr, size, flags);
> >  > +             if (ret < 0)
> >  > +                     return ret;
> >  > +     }
> >  > +     list_for_each_entry(bdata, &bdata_list, list)
> >  > +             reserve_bootmem_core(bdata, addr, size, flags);
> >  > +     return 0;
> >  >  }
> >
> >  why list_for_each twice ?
> 
> first_for_each only check if we can reserve that.
> second will do the reserve job.
> 
Hmm, can a call to reserve_bootmem() return a memory region which spread across
prural nodes ?


Thanks,
-Kame 

