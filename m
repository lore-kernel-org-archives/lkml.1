Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZI2OsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZI2OsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2OsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:48:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45580 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI2OsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:48:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH] connector: Allow permission checking in the receiver callbacks
Date: Tue, 29 Sep 2009 16:48:07 +0200
Message-Id: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various users of the connector should actually check if the
sender's capabilities of a netlink/connector packet are
actually sufficient for the operation they trigger. Up to
now the connector framework did not allow the kernel side
receiver to do so.

This patch set does the groundwork.

Philipp Reisner (4):
  connector: Keep the skb in cn_callback_data
  connector: Provide the sender's credentials to the callback
  connector/dm: Fixed a compilation warning
  connector: Removed the destruct_data callback since it is always
    kfree_skb()

 Documentation/connector/cn_test.c      |    2 +-
 Documentation/connector/connector.txt  |    8 ++++----
 drivers/connector/cn_queue.c           |   12 +++++++-----
 drivers/connector/connector.c          |   22 ++++++++--------------
 drivers/md/dm-log-userspace-transfer.c |    3 +--
 drivers/staging/dst/dcore.c            |    2 +-
 drivers/staging/pohmelfs/config.c      |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 drivers/w1/w1_netlink.c                |    2 +-
 include/linux/connector.h              |   11 ++++-------
 10 files changed, 29 insertions(+), 37 deletions(-)

