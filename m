Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYKYLf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYKYLf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYKYLfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:35:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38368 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKYLfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:35:15 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, akpm@linux-foundation.org
In-Reply-To: <20081124145057.4211bd46@bree.surriel.com>
References: <20081124145057.4211bd46@bree.surriel.com>
Message-Id: <20081125203333.26F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 20:35:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sometimes the VM spends the first few priority rounds rotating back
> referenced pages and submitting IO.  Once we get to a lower priority,
> sometimes the VM ends up freeing way too many pages.
> 
> The fix is relatively simple: in shrink_zone() we can check how many
> pages we have already freed, direct reclaim tasks break out of the
> scanning loop if they have already freed enough pages and have reached
> a lower priority level.
> 
> However, in order to do this we do need to know how many pages we already
> freed, so move nr_reclaimed into scan_control.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> Kosaki, this should address the zone scanning pressure issue.

hmmmm. I still don't like the behavior when priority==DEF_PRIORITY.
but I also should explain by code and benchmark.

therefore, I'll try to mesure this patch in this week.

thanks.


