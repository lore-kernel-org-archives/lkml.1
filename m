Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYFKX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYFKX65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYFKX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:58:49 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41380 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751091AbYFKX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:58:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GLVgWPS/ZoJoatYlvmfxHwuMw3mxUScB/tND/xwZ/VL7nSPK6SnZDCWianL0tNwtegntCEouvAWOdF5enCCJHewoTjj3YxHTlpaKctvruZzmDh1uf7smT+twROl7sB8xv/Sf8oJ5sjRRbRoMhTvL6iJHnuiRz5+9cbNHdIAJYuc=  ;
X-YMail-OSG: 1uZ_uCAVM1nMGFuiJIwuXONUsV7GQxoEZduTwQ5jz.0dNRcdc9QM0F8sXuZmFF4ovpayRTeOTzY6V9w2yEdLcAXOQn5Ilc.2CVIZlVoISiJ_SAYVxAve2T7_jyhWIO7vCzg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.26-rc5-mm2
Date: Thu, 12 Jun 2008 09:58:38 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806101848.22237.nickpiggin@yahoo.com.au> <20080611140902.544e59ec@bree.surriel.com>
In-Reply-To: <20080611140902.544e59ec@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806120958.38545.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 04:09, Rik van Riel wrote:
> On Tue, 10 Jun 2008 18:48:21 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > The tmpfs PageSwapBacked stuff seems rather broken. For
> > > > them write_begin/write_end path, it is filemap.c, not shmem.c,
> > > > which allocates the page, so its no wonder it goes bug. Will
> > > > try to do more testing without shmem.
>
> Fun, so what does shmem_alloc_page do?
>
> > > rikstuff.  Could be that the merge caused a problem?
> >
> > Doesn't look like it, but I hadn't followed the changes too closely:
> > rather they just need to test loopback over tmpfs.
>
> Does loopback over tmpfs use a different allocation path?

I'm sorry, hmm I didn't look closely enough and forgot that
write_begin/write_end requires the callee to allocate the page
as well, and that Hugh had nicely unified most of that.

So maybe it's not that. It's pretty easy to hit I found with
ext2 mounted over loopback on a tmpfs file.


> > Is the plan to merge all reclaim changes in a big hit, rather than
> > slowly trickle in the different independent changes?
>
> My original plan was to merge them incrementally, but Andrew is
> right that we should give the whole set as much testing as
> possible.
>
> I have done all the cleanups Andrew asked and fixed the bugs
> that I found after that merge/cleanup.  Your bug is the one
> I still need to fix before giving Andrew a whole new set of
> split LRU patches to merge.
>
> (afterwards, I will go incremental fixes only - the cleanups
> he asked for were just too big to do as incrementals)

OK.
