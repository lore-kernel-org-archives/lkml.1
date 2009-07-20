Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZGTQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZGTQPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZGTQPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:15:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36019 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZGTQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:15:39 -0400
Date: Tue, 21 Jul 2009 01:15:05 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] hibernate / memory hotplug: always use for_each_populated_zone()
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
In-Reply-To: <1248103551.23961.0.camel@localhost.localdomain>
References: <1248103551.23961.0.camel@localhost.localdomain>
Message-Id: <20090721011344.AF78.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> Use for_each_populated_zone() instead of for_each_zone() in hibernation
> code. This fixes a bug on s390, where we allow both config options
> HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> here. We only allow hibernation if no memory hotplug operation was
> performed, so in fact both features can only be used exclusively, but
> this way we don't need 2 differently configured (distribution) kernels.
> 
> If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> code iterates through all zones, not only the populated zones, in
> several places. For example, swsusp_free() does for_each_zone() and
> then checks for pfn_valid(), which is true even if the zone is not
> populated, resulting in a BUG_ON() later because the pfn cannot be
> found in the memory bitmap.
> 
> Replacing all occurences of for_each_zone() in hibernation code with
> for_each_populated_zone() would fix this issue.
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Thanks this effort.
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



