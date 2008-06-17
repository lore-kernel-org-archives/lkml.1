Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYFQPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYFQPdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbYFQPdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:33:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56291 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbYFQPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:33:31 -0400
Date: Wed, 18 Jun 2008 00:33:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
Message-Id: <20080618003129.DE27.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -715,13 +725,7 @@ unlock:
>   		 * restored.
>   		 */
>   		list_del(&page->lru);
> -		if (!page->mapping) {
> -			VM_BUG_ON(page_count(page) != 1);
> -			unlock_page(page);
> -			put_page(page);		/* just free the old page */
> -			goto end_migration;
> -		} else
> -			unlock = putback_lru_page(page);
> +		unlock = putback_lru_page(page);
>  	}
>  
>  	if (unlock)

this part is really necessary?
I tryed to remove it, but any problem doesn't happend.

Of cource, another part is definitly necessary for specurative pagecache :)




