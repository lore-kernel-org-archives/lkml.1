Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZI1D7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZI1D7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZI1D7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:59:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33578 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZI1D7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:59:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Sep 2009 12:57:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090928033624.GA11191@localhost>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 11:36:24 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Mon, Sep 28, 2009 at 11:04:50AM +0800, KAMEZAWA Hiroyuki wrote:
 
> > But, yes it implies to add a new argument to several functions in mmap.c
> > and maybe a patch will be ugly.
> > 
> > How about addding this check ?
> > 
> > is_mergeable_vma(...)
> > ....
> >   if (vma->vm_hints)
> > 	return 0;
> > 
> > And not calling vma_merge() at madvice(ACCESS_PATTERN_HINT).
> > 
> > I wonder there are little chances when madice(ACCESS_PATTERN_HINT) is
> > given against mapped-file-vma...
> 
> Me wonder too. The access hints should be rarely used.
> A simple solution is reasonable for them.
> 
> But what if more flags going into vm_hints in future?
> 

yes, that's concern...

But I wonder there are several flags which implies that the vma is not for
merge. as....

#define VM_GROWSDOWN    0x00000100      /* general info on the segment */
#define VM_GROWSUP      0x00000200

or some PFN_MAP flags...
(At least, we can have 4 flags of not-for-merge in vm_hints ;)

Then, Nigel, you have 2 choices I think.

  (1) don't merge if vm_hints is set  or
  (2) pass vm_hints to all __merge() functions.

One of above will be accesptable for stakeholders...
I personally like (1) but just trying (2) may be accepted.

What I dislike is making vm_flags to be long long ;)

Thanks,
-Kame

