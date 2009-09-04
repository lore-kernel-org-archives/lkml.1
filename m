Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbZIDT2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbZIDT2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933904AbZIDT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:28:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46203 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886AbZIDT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:28:03 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] pci: Remove bogus check of proc dir entry usage.
References: <m1fxb2wm0z.fsf@fess.ebiederm.org>
	<m1bplqwlzr.fsf@fess.ebiederm.org>
	<m17hwewlxr.fsf_-_@fess.ebiederm.org>
	<m13a72wlwm.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Sep 2009 12:28:03 -0700
In-Reply-To: <m13a72wlwm.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Fri\, 04 Sep 2009 12\:27\:21 -0700")
Message-ID: <m1ws4ev7b0.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, tj@kernel.org, gregkh@suse.de, adobriyan@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This check prevents /proc/bus/pci/*/* from being removed when
pci devices are hot unpluged and someone happens to have it open.
This is not a problem because proc handles this case properly.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/pci/proc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 593bb84..afd2a6a 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -430,8 +430,6 @@ int pci_proc_detach_device(struct pci_dev *dev)
 	struct proc_dir_entry *e;
 
 	if ((e = dev->procent)) {
-		if (atomic_read(&e->count) > 1)
-			return -EBUSY;
 		remove_proc_entry(e->name, dev->bus->procdir);
 		dev->procent = NULL;
 	}
-- 
1.6.2.5

