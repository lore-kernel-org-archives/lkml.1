Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYIKVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYIKVmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYIKVmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:42:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbYIKVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:42:16 -0400
Date: Thu, 11 Sep 2008 14:41:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org
Subject: Re: [PATCH] Mark the correct zone as full when scanning zonelists
Message-Id: <20080911144155.c70ef145.akpm@linux-foundation.org>
In-Reply-To: <20080911212550.GA18087@csn.ul.ie>
References: <20080911212550.GA18087@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 22:25:51 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The for_each_zone_zonelist() uses a struct zoneref *z cursor when scanning
> zonelists to keep track of where in the zonelist it is. The zoneref that
> is returned corresponds to the the next zone that is to be scanned, not
> the current one as it originally thought of as an opaque list.
> 
> When the page allocator is scanning a zonelist, it marks zones that it
> temporarily full zones to eliminate near-future scanning attempts.

That sentence needs help.

> It uses
> the zoneref for the marking and consequently the incorrect zone gets marked
> full. This leads to a suitable zone being skipped in the mistaken belief
> it is full. This patch corrects the problem by changing zoneref to be the
> current zone being scanned instead of the next one.

Applicable to 2.6.26 as well, yes?


Someone reported a bug a few weeks ago which I think this patch will fix,
yes?  I don't remember who that was, nor do I recall the precise details
of what the userspace-visible (mis)behaviour was.

Are you able to fill in the gaps here?  Put yourself in the position of
a poor little -stable maintainer scratching his head wondering ytf he
was sent this patch.

Thanks.
