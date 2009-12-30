Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZL3DLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZL3DLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZL3DLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:11:30 -0500
Received: from waste.org ([173.11.57.241]:48289 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbZL3DL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:11:29 -0500
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
From: Matt Mackall <mpm@selenic.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20091230103349.1ec71aac.minchan.kim@barrios-desktop>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	 <1262117339.3000.2023.camel@calx>
	 <20091230103349.1ec71aac.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 21:11:26 -0600
Message-ID: <1262142686.3000.2140.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 10:33 +0900, Minchan Kim wrote:
> Hi, Matt. 
> 
> On Tue, 29 Dec 2009 14:08:59 -0600
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Mon, 2009-12-28 at 13:46 +0900, Minchan Kim wrote:
> > > I am not sure we have to account zero page with file_rss. 
> > > Hugh and Kame's new zero page doesn't do it. 
> > > As side effect of this, we can prevent innocent process which have a lot
> > > of zero page when OOM happens. 
> > > (But I am not sure there is a process like this :)
> > > So I think not file_rss counting is not bad. 
> > > 
> > > RSS counting zero page with file_rss helps any program using smaps?
> > > If we have to keep the old behavior, I have to remake this patch. 
> > > 
> > > == CUT_HERE ==
> > > 
> > > Long time ago, We regards zero page as file_rss and
> > > vm_normal_page doesn't return NULL.
> > > 
> > > But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
> > > can return NULL in case of zero page. Also we don't count it with
> > > file_rss any more.
> > > 
> > > Then, RSS and PSS can't be matched.
> > > For consistency, Let's ignore zero page in smaps_pte_range.
> > > 
> > 
> > Not counting the zero page in RSS is fine with me. But will this patch
> > make the total from smaps agree with get_mm_rss()?
> 
> Yes. Anon page fault handler also don't count zero page any more, now. 
> Nonetheless, smaps counts it with resident. 

Ok, great.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


