Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZGNWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZGNWCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZGNWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:02:41 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:13943 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbZGNWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:02:40 -0400
Subject: [PATCH 0/3] cciss rmmod/scan-thread fixes
To: linux-kernel@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com,
       jens.axboe@oracle.com
Date: Tue, 14 Jul 2009 16:02:40 -0600
Message-ID: <20090714220239.22282.44414.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes several problems causing hangs while
rmmoding the cciss driver. In the process of fixing these hangs, I
also reworked the the logical drive scanning kernel thread to use one
thread per driver rather than one thread per controller. I also added
a sysfs attribute to kick off a controller scan.

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
 drivers/block/cciss.c                              |  198 ++++++++++++++++++--
 drivers/block/cciss.h                              |    7 +
 3 files changed, 188 insertions(+), 24 deletions(-)

Andrew Patterson (3):
      cciss: remove logical drive sysfs entries during driver cleanup.
      cciss: use only one scan thread
      cciss: kick off logical drive topology rescan through sysfs



-- 
Andrew Patterson
