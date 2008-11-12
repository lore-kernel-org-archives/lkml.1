Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbYKLCU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbYKLCU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYKLCUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:20:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52352 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYKLCUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:20:13 -0500
Date: Wed, 12 Nov 2008 11:19:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
Message-Id: <20081112111931.0e40c27d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081111222421.GL10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<1226409701-14831-2-git-send-email-ieidus@redhat.com>
	<1226409701-14831-3-git-send-email-ieidus@redhat.com>
	<20081111114555.eb808843.akpm@linux-foundation.org>
	<4919F1C0.2050009@redhat.com>
	<Pine.LNX.4.64.0811111520590.27767@quilx.com>
	<4919F7EE.3070501@redhat.com>
	<Pine.LNX.4.64.0811111527500.27767@quilx.com>
	<20081111222421.GL10818@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 23:24:21 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Tue, Nov 11, 2008 at 03:31:18PM -0600, Christoph Lameter wrote:
> > > ksm need the pte inside the vma to point from anonymous page into filebacked
> > > page
> > > can migrate.c do it without changes?
> > 
> > So change anonymous to filebacked page?
> >
> > Currently page migration assumes that the page will continue to be part
> > of the existing file or anon vma.
> > 
> > What you want sounds like assigning a swap pte to an anonymous page? That
> > way a anon page gains membership in a file backed mapping.
> 
> KSM needs to convert anonymous pages to PageKSM, which means a page
> owned by ksm.c and only known by ksm.c. The Linux VM will free this
> page in munmap but that's about it, all we do is to match the number
> of anon-ptes pointing to the page with the page_count. So besides
> freeing the page when the last user exit()s or cows it, the VM will do
> nothing about it. Initially. Later it can swap it in a nonlinear way.
> 
Can I make a question ? (I'm working for memory cgroup.)

Now, we do charge to anonymous page when
  - charge(+1) when it's mapped firstly (mapcount 0->1)
  - uncharge(-1) it's fully unmapped (mapcount 1->0) vir page_remove_rmap().

My quesion is
 - PageKSM pages are not necessary to be tracked by memory cgroup ?
 - Can we know that "the page is just replaced and we don't necessary to do
   charge/uncharge".
 - annonymous page from KSM is worth to be tracked by memory cgroup ?
   (IOW, it's on LRU and can be swapped-out ?)

Thanks,
-Kame


