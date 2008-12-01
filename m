Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbYLAGAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbYLAGAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYLAF77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:59:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54873 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYLAF76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:59:58 -0500
Date: Mon, 1 Dec 2008 14:59:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/3] cgroup id and scanning without cgroup_lock
Message-Id: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches againse mmotm-Nov29
(passed easy test)

Now, memcg supports hierarhcy. But walking cgroup tree in intellegent way
with lock/unlock cgroup_mutex seems to have troubles rather than expected.
And, I want to reduce the memory usage of swap_cgroup, which uses array of
pointers.

This patch series provides
	- cgroup_id per cgroup object.
	- lookup struct cgroup by cgroup_id
	- scan all cgroup under tree by cgroup_id. without mutex.
	- css_tryget() function.
	- fixes semantics of notify_on_release. (I think this is valid fix.)

Many changes since v1. (But I wonder some more work may be neeeded.)

BTW, I know there are some amount of patches against memcg are posted recently.
If necessary, I'll prepare Weekly-update queue again (Wednesday) and
picks all patches to linux-mm in my queue.

Thanks,
-Kame

