Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYFXJyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYFXJyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYFXJyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:54:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56510 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYFXJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:54:14 -0400
Date: Tue, 24 Jun 2008 18:59:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling
 rework v3
Message-Id: <20080624185928.e06a79f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 18:49:05 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > +	mem_cgroup_move_lists(page, lru);
> > +
> > +	/*
> > +	 * page's status can change while we move it among lru. If an evictable
> > +	 * page is on unevictable list, it never be freed. To avoid that,
> > +	 * check after we added it to the list, again.
> > +	 */
> > +	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
> > +		if (!isolate_lru_page(page)) {
> > +			put_page(page);
> > +			goto redo;
> 
> at this point, We should call ClearPageUnevictable().
> otherwise, BUG() is called on isolate_lru_pages().
> 
Sure. thanks,
-Kame

