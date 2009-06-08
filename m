Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZFHNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZFHNcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZFHNcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:32:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZFHNcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:32:08 -0400
Message-ID: <4A2D129D.3020309@redhat.com>
Date: Mon, 08 Jun 2009 09:31:09 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when zone_reclaim()
 scans and fails to avoid CPU spinning at 100% on NUMA
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1244466090-10711-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> The scanning occurs because zone_reclaim() cannot tell
> in advance the scan is pointless because the counters do not distinguish
> between pagecache pages backed by disk and by RAM. 

Yes it can.  Since 2.6.27, filesystem backed and swap/ram backed
pages have been living on separate LRU lists.  This allows you to
fix the underlying problem, instead of having to add a retry
interval.

-- 
All rights reversed.
