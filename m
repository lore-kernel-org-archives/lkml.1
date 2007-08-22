Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXHVCRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXHVCRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbXHVCQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:16:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:42894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbXHVCQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:16:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,291,1183359600"; 
   d="scan'208";a="286157473"
Subject: bug in migrate page
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Content-Type: text/plain
Date: Wed, 22 Aug 2007 10:08:09 +0800
Message-Id: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit dc386d4d1e98bb39fb967ee156cd456c802fc692 adds rcu_read_lock, but
some routines in the lock range might sleep (like lock_buffer,
aops->writepage), I saw a 'sleep in atomic' warning. It appears the
patch has several versions before. Doing rcu_read_lock in PageAnon
sounds break the case of PageAnon(page) && PageSwapCache(page),
as .writepage might be called. The dummy anon patch maybe is ok.

Thanks,
Shaohua
