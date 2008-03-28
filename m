Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYC1Qmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYC1Qmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYC1Qlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:41:55 -0400
Received: from mail04.svc.cra.dublin.eircom.net ([159.134.118.20]:43614 "HELO
	mail04.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753423AbYC1Qlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:41:55 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, xen-devel@lists.xensource.com
Subject: [PATCH 0/3] xen: Fix oops when mapping/unmapping addr above 1Gb
Date: Fri, 28 Mar 2008 16:38:14 +0000
Message-Id: <1206722297-11763-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
        In Fedora rawhide we're currently seeing oopses whenever
a processes dlopen()s a library which prelink() has previously
relocated above 1Gb. Some more details at:

  https://bugzilla.redhat.com/436453

        The issue seems to be that during xen_pgd_pin(), we only
pin PTE pages, but xen's release_pmd() tries to unpin PMD pages
too.

        The following series of patches is against the latest
x86 tree.

Cheers,
Mark.

