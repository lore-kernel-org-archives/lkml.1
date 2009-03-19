Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZCSNyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZCSNyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZCSNyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:54:46 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27166 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbZCSNyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:54:45 -0400
Subject: Btrfs changes for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 09:53:25 -0400
Message-Id: <1237470805.18446.22.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49C24E58.0246:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

The master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Has two commits fixing problems with adding devices or growing devices
in a btrfs filesystem.  

Basically the code that actually allocates space wasn't being properly
told about the new space, and so the only way to make use of it was to
unmount and mount again.


Chris Mason (2):
      Btrfs: Fix locking around adding new space_info
      Btrfs: Clear space_info full when adding new devices

 
 fs/btrfs/ctree.h       |    9 +++++++++
 fs/btrfs/extent-tree.c |   45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c     |    8 ++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

