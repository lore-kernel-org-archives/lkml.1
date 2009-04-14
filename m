Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZDNOPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZDNOPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZDNOPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:15:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZDNOPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:15:34 -0400
Date: Tue, 14 Apr 2009 16:12:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Message-ID: <20090414141209.GB31644@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <200904141925.46012.nickpiggin@yahoo.com.au> <2f11576a0904140502h295faf33qcea9a39ff7f230a5@mail.gmail.com> <200904142225.10788.nickpiggin@yahoo.com.au> <2f11576a0904140639l426e137ewdc46296cdb377dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0904140639l426e137ewdc46296cdb377dd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:39:54PM +0900, KOSAKI Motohiro wrote:
> I guess you dislike get_user_page_fast() grab pte_lock too, right?

If get_user_page_fast is vetoed to run a set_bit on the already cache
hot and exclusive struct page, I doubt taking a potentially cache
cold, mm-wide or pmd-wide pte_lock is ok.
