Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZFWFNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZFWFNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZFWFNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:13:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52549 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFWFNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:13:23 -0400
Date: Tue, 23 Jun 2009 14:11:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akataria@vmware.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
Message-Id: <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090623135017.220D.A69D9226@jp.fujitsu.com>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	<1245732411.18339.6.camel@alok-dev1>
	<20090623135017.220D.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 14:05:47 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> I'm not sure this unevictable definition is good idea or not. currently
> hugepage isn't only non-account memory, but also various kernel memory doesn't
> account.
> 
> one of drawback is that zone_page_state(UNEVICTABLE) lost to mean #-of-unevictable-pages.
> e.g.  following patch is wrong?
> 
> fs/proc/meminfo.c meminfo_proc_show()
> ----------------------------
> -                K(pages[LRU_UNEVICTABLE]),
> +                K(pages[LRU_UNEVICTABLE]) + hstate->nr_huge_pages,
> 
> 
> Plus, I didn't find any practical benefit in this patch. do you have it?
> or You only want to natural definition?
> 
> I don't have any strong oppose reason, but I also don't have any strong
> agree reason.
> 
I think "don't include Hugepage" is sane. Hugepage is something _special_, now.

Thanks,
-Kame

