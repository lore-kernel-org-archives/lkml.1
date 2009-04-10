Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZDJD1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZDJD1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763584AbZDJD1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:27:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50930 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbZDJD1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:27:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Document get_user_pages_fast()
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Grover <andy.grover@oracle.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, npiggin@suse.de
In-Reply-To: <20090409201309.db1c2c52.akpm@linux-foundation.org>
References: <20090410110626.7931.A69D9226@jp.fujitsu.com> <20090409201309.db1c2c52.akpm@linux-foundation.org>
Message-Id: <20090410121923.7939.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 10 Apr 2009 12:27:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is one problem.
> > gup and get_page() don't provide any page pinning.
> > 
> > get_page() only gurantee not freed. but don't gurantee to prevent page
> > reclaim
> 
> is_page_cache_freeable() measures page_count()...

sorry, my explanation was too short. 

reclaim can unmap the page. but page migration assume unmap successing mean
page migratable, then user-address associate another page and lost writing data
to old page.

IOW

     CPU0              CPU1                 note
------------------------------------------------------
    gup()
                    page-migration         user-address attach another page
 write data to                             write to old page.
 gup()ed page                              userland can't see it.

   put_page()                              free old page.


> 
> > and Cow change owner process.
> 
> hm.  buggy userspace? Why is that a problem from a kernel perspective?

We already started to discuttion in "[PATCH] fork vs gup(-fast) fix" thread.
but this is very difficult problem. it is still in progress ;)



> > Yes, current all gup caller have serious bug. especially direct-io, aio, bio
> > are broken.



