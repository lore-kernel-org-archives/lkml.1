Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZDNNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZDNNmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZDNNmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:42:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZDNNmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:42:31 -0400
Date: Tue, 14 Apr 2009 15:41:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-api@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
Message-ID: <20090414134109.GD28265@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <20090414151924.C653.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414151924.C653.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:20:20PM +0900, KOSAKI Motohiro wrote:
> In addition, This patch has good side effect. it also fix "get_user_pages() vs fork" problem.

Yes, patches like 3/6, 4/6, and 6/6 are the side effect of not fixing
the core race in gup and spreading the new rwsem around the gup users,
instead of sticking to a page-granular PG_flag touched at the same
time atomic_inc runs on page->_count.
