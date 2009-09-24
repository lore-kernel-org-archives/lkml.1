Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZIXCao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZIXCao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 22:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZIXCan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 22:30:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59843 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZIXCam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 22:30:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Sep 2009 11:28:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Max Laier <max@love2party.net>, linux-kernel@vger.kernel.org
Subject: Re: page_migration question
Message-Id: <20090924112838.33414fc6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0909200826540.21574@V090114053VZO-1>
References: <200909200501.59164.max@love2party.net>
	<alpine.DEB.1.10.0909200826540.21574@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 08:30:15 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Sun, 20 Sep 2009, Max Laier wrote:
> 
> > I read Documentation/vm/page_migration but couldn't find the information I'm
> > looking for.  Specifically, what locks am I supposed to hold/not hold while
> > calling migrate_prep() and migrate_pages()?  Currently migrate_prep() seems to
> > deadlock for reasons beyond me.  Any help appreciated.
> 
> No locks need to be held while calling migrate prep. The pages to be
> migrated must have been isolated from the LRU and a refcount be taken for
> migrate_pages to work. Look at the implementation of sys_migratepages and
> sys_mbind and sys_movepages.
> 

If you find migrate_prep() hangs, please check your other cpus are available to
run workqueue. It calls lru_add_drain_all()=>schedule_on_each_cpu().

Thanks,
-Kame

