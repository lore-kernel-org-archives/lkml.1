Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZDVRM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZDVRM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZDVRMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:12:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57360 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZDVRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:11:59 -0400
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone
	watermark
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 10:11:53 -0700
Message-Id: <1240420313.10627.85.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 14:53 +0100, Mel Gorman wrote:
>  struct zone {
>         /* Fields commonly accessed by the page allocator */
> -       unsigned long           pages_min, pages_low, pages_high;
> +       union {
> +               struct {
> +                       unsigned long   pages_min, pages_low, pages_high;
> +               };
> +               unsigned long pages_mark[3];
> +       };

Why the union?  It's a bit obfuscated for me.  Why not just have a
couple of these:

static inline unsigned long zone_pages_min(struct zone *zone)
{
	return zone->pages_mark[ALLOC_WMARK_MIN];
}

and s/zone->pages_min/zone_pages_min(zone)/

?

-- Dave

