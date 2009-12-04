Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZLDNwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZLDNwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZLDNwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:52:41 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:43929 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZLDNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:52:40 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] block: io_context refcount fixes
Date: Fri,  4 Dec 2009 14:52:40 +0100
Message-Id: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

When reading copy_io() I found probable refcounting issues with shared
io_context. IIUC, the following two patches could fix those issues.
If I am correct, then those fixes should go to stable too.

Based on v2.6.32 and compile-tested only.

Thanks,

Louis

Louis Rilling (2):
      block: Fix io_context leak after clone with CLONE_IO
      block: Fix io_context leak after failure of clone with CLONE_IO

 block/blk-ioc.c           |   12 ++++++------
 include/linux/iocontext.h |    5 +++--
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    3 ++-
 4 files changed, 12 insertions(+), 10 deletions(-)
-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
