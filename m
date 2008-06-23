Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYFWDZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYFWDZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYFWDZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:25:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50393 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYFWDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:25:38 -0400
Date: Mon, 23 Jun 2008 12:25:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v6
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080609162015.GD14939@sgi.com>
References: <20080609162015.GD14939@sgi.com>
Message-Id: <20080623121721.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> +static ssize_t
> +badpage_show(struct kobject *kobj,
> +	     struct kobj_attribute *attr, char *buf)
> +
> +{
> +	struct page *page, *page2;
> +	int i = 0, cnt = 0;
> +	char *bufend = buf + PAGE_SIZE;
> +
> +	cnt = snprintf(buf, bufend - (buf + cnt),
> +			"Bad RAM: %d kB, %d pages marked bad\n"
> +			"List of bad physical pages\n",
> +			total_badpages << (PAGE_SHIFT - 10), total_badpages);
> +
> +	list_for_each_entry_safe(page, page2, &badpagelist, lru) {
> +		if (bufend - (buf + cnt) < 20)
> +			break;		/* Avoid overflowing the buffer */
> +		cnt += snprintf(buf + cnt, bufend - (buf + cnt),
> +				" 0x%011lx", page_to_phys(page));
> +		if (!(++i % 5))
> +			cnt += snprintf(buf + cnt, bufend - (buf + cnt), "\n");
> +	}
> +	cnt += snprintf(buf + cnt, bufend - (buf + cnt), "\n");
> +
> +	return cnt;
> +}

it seems /proc/meminfo is better.
because badpage is architecture independent concept.

nonsense?


