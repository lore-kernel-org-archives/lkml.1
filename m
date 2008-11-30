Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYK3M0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYK3M0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 07:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYK3MZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 07:25:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30765 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYK3MZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 07:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AiBbKfXVu3q49UcCnREqQTN2qcjma/RRUAqRrsPwzm9FgMMQgRvzoS2teadXn8TFo/
         ux+U5cvmTXkswWBKZg+0ehF7x/AnrGADAX44mwwgN29SfCAL4GVZI6JI6vTI4R9pcaZ6
         vx3q552mBKA4OHaus5VWbrQ4bj1+Gy6imgzhs=
Date: Sun, 30 Nov 2008 15:25:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 02/09] memcg: make inactive_anon_is_low()
Message-ID: <20081130122554.GA12552@localhost>
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KOSAKI Motohiro - Sun, Nov 30, 2008 at 07:56:37PM +0900]
| make inactive_anon_is_low for memcgroup.
| it improve active_anon vs inactive_anon ratio balancing.
| 
| 
| Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
| ---
...
| +static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
| +{
| +	unsigned int gb, ratio;
| +
| +	gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
| +	ratio = int_sqrt(10 * gb);
| +	if (!ratio)
| +		ratio = 1;

Hi Kosaki,

maybe better would be

	gb = ...;
	if (gb) {
		ratio = int_sqrt(10 * gb);
	} else
		ratio = 1;

| +
| +	memcg->inactive_ratio = ratio;
| +
| +}
| +
...

		- Cyrill -
