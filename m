Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXFRQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXFRQ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXFRQ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:56:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49352 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752802AbXFRQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:56:21 -0400
Date: Mon, 18 Jun 2007 09:56:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/7] KAMEZAWA Hiroyuki hot-remove patches
In-Reply-To: <20070618092841.7790.48917.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0706180954320.4751@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
 <20070618092841.7790.48917.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Mel Gorman wrote:

> @@ -632,18 +632,27 @@ static int unmap_and_move(new_page_t get
>  			goto unlock;
>  		wait_on_page_writeback(page);
>  	}
> -
> +	/* anon_vma should not be freed while migration. */
> +	if (PageAnon(page)) {
> +		rcu_read_lock();
> +		rcu_locked = 1;
> +	}

We agreed on doing rcu_read_lock removing the status variable 
and checking for PageAnon(). Doing so deuglifies the 
function.
