Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZIDQwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZIDQwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZIDQwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:52:39 -0400
Received: from mail.memset.com ([89.200.136.113]:46299 "EHLO mail.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbZIDQwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:52:38 -0400
Date: Fri, 4 Sep 2009 17:52:43 +0100
From: Nick Craig-Wood <nick@craig-wood.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Reading /proc/kcore causes a BUG()
Message-ID: <20090904165243.GA32200@craig-wood.com>
References: <20090903113428.GA6986@craig-wood.com> <84144f020909030514k1d9fe596pf2c4d8ffa45f7af@mail.gmail.com> <20090904090642.f727458b.kamezawa.hiroyu@jp.fujitsu.com> <20090904090039.GA25804@craig-wood.com> <20090904181645.d114d1c9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090904181645.d114d1c9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:16:45PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 4 Sep 2009 10:00:39 +0100
> Nick Craig-Wood <nick@craig-wood.com> wrote:
> 
> > On Fri, Sep 04, 2009 at 09:06:42AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Thu, 3 Sep 2009 15:14:55 +0300
> > > Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > > On Thu, Sep 3, 2009 at 2:34 PM, Nick Craig-Wood<nick@craig-wood.com> wrote:
> > > > > Is a fix for this going to make 2.6.31?
> > > > >
> > > > > To replicate
> > > > >
> > > > >  cat /proc/kcore >/dev/null
> > > > >
> > > > > See also
> > > > >
> > > > >  http://bugzilla.kernel.org/show_bug.cgi?id=13850
> > [snip]
> > > > > I tried this on the latest git checkout (as of 2009-09-03 11:00 GMT)
> > > > > under Xen as a domU.  The bugzilla report states it happens on non xen
> > > > > machines also.
> > > > >
> > > > > I know reading /proc/kcore isn't such a good idea, but badly written
> > > > > backup scripts are triggering this on our customer's servers :-(
> > > > 
> > > > AFAICT the bug was fixed but I can't seem to find the patches in
> > > > Linus' git either. Lets CC Andrew and Hiroyuki-san.
> > > 
> > > Ah, it's now tested under mmotm. please wait.
> > 
> > I tried mmotm but I couldn't get it to boot under Xen :-(
> > 
> > If you send me a patch against latest git I'm willing to test it (I
> > tried to extract the relevant patch from mmotm but failed dismally)
> 
> If you already downloaded mmotm, use these patches.
> 
> vmalloc-unmap-vmalloc-area-after-hiding-it.patch
> kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
> kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
> kcore-proc-kcore-should-use-vread.patch
> 
> All I tested was x86-32/x86-64. then more tests are welcomed.

I can confirm that these patches fix the problem on x86-32 running
under Xen DomU - thank you very much.

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
