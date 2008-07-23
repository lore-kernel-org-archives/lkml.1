Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYGWCvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYGWCvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 22:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYGWCu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 22:50:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35896 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYGWCuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 22:50:55 -0400
Date: Wed, 23 Jul 2008 11:48:00 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: memory hotplug: hot-remove fails on lowest chunk in ZONE_MOVABLE
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1216745719.4871.8.camel@localhost.localdomain>
References: <1216745719.4871.8.camel@localhost.localdomain>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080723105318.81BC.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.


> I've been testing memory hotplug on s390, on a system that starts w/o
> memory in ZONE_MOVABLE at first, and then some memory chunks will be
> added to ZONE_MOVABLE via memory hot-add. Now I observe the following
> problem:
> 
> Memory hot-remove of the lowest memory chunk in ZONE_MOVABLE will fail
> because of some reserved pages at the beginning of each zone
> (MIGRATE_RESERVED).
> 
> During memory hot-add, setup_per_zone_pages_min() will be called from
> online_pages() to redistribute/recalculate the reserved page blocks.
> This will mark some page blocks at the beginning of each zone as
> MIGRATE_RESERVE. Now, the memory chunk containing these blocks cannot
> be set offline again, because only MIGRATE_MOVABLE pages can be isolated
> (offline_pages -> start_isolate_page_range).
> 
> So you cannot remove all the memory chunks that have been added via
> memory hotplug. I'm not sure if I am missing something here, or if this
> really is a bug. Any thoughts?

I believe you are right. Current hot-remove code is NOT perfect.
You may remove some sections, but may not other sections,
because there are some un-removable pages by some reasons
(not only MIGRATE_RESERVED).

I think MIGRATE_RESERVED pages should be move to MIGRATE_MOVABLE when 
those pages must be removed, and should recalculate MIGRATE_RESERVED pages.

Bye.

-- 
Yasunori Goto 


