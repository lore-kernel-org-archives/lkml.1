Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZL2EFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZL2EFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 23:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZL2EFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 23:05:38 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:47855 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZL2EFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 23:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MnXOSsioK1g3MPW/pekn5rCr2pdiVYliFPbxP87f7sJjzvODeKy4y8LtdYuRQ2zI6g
         /7U47vKorhxu2EjH6fQH65bzSTXvpf/ZsG1oqsDPxdu14jcXkMXiCbdpiSvGFU+XFTFR
         7FM96tQ+Lvw3GzIZ32sesPAbsefYJvrhG+tgY=
MIME-Version: 1.0
In-Reply-To: <20091228164451.A687.A69D9226@jp.fujitsu.com>
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
Date: Tue, 29 Dec 2009 13:05:37 +0900
Message-ID: <28c262360912282005x68315a62l7ffde637febc7646@mail.gmail.com>
Subject: Re: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 4:47 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> The zone->lock is one of performance critical locks. Then, it shouldn't
> be hold for long time. Currently, we have four walk_zones_in_node()
> usage and almost use-case don't need to hold zone->lock.

I agree.

We can use walk_zone_in_node freely to show the information related to zone.

- frag_show_print : the number of free pages per order.
- pagetypeinfo_showfree_print : the number of free page per migration type
- pagetypeinfo_showblockcount_print : the number of pages in zone per
migration type
- zoneinfo_show_print : many info about zone.

Do we want to show exact value? No.
If we want it, it's not enough zone->lock only.
After all, All of things would be transient value.

>
> Thus, this patch move locking responsibility from walk_zones_in_node
> to its sub function. Also this patch kill unnecessary zone->lock taking.
>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
