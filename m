Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZLOKTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZLOKTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbZLOKTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:19:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbZLOKTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:19:12 -0500
Date: Tue, 15 Dec 2009 11:18:21 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 0/4 -mmotm] copy_signal() cleanup
Message-ID: <20091215101821.GA9134@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com> <20091207123615.fc841a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207123615.fc841a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmem_cache_zalloc() instead of kmem_cache_alloc() and remove all
unneeded initializations from copy_signal() and several other functions.
Should be applied on top of 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
commit.

 drivers/char/tty_audit.c       |    1 -
 include/linux/acct.h           |    2 --
 include/linux/sched.h          |    2 --
 include/linux/taskstats_kern.h |    7 -------
 kernel/acct.c                  |   10 ----------
 kernel/fork.c                  |   38 +-------------------------------------
 6 files changed, 1 insertions(+), 59 deletions(-)
---
