Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYGGUG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYGGUG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYGGUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:06:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbYGGUGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:06:21 -0400
From: Bill Nottingham <notting@redhat.com>
To: bridge@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Allow full bridge configuration via sysfs
Date: Mon,  7 Jul 2008 16:05:02 -0400
Message-Id: <cover.1215460681.git.notting@redhat.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, you can configure most bridge device parameters via sysfs.
However, you cannot either:
- add or remove bridge interfaces
- add or remove physical interfaces from a bridge

The attached patch set rectifies this. With this patch set, brctl
(theoretically) becomes completely optional, much like ifenslave is
now for bonding. (In fact, the idea for this patch, and the syntax
used herein, is inspired by the sysfs bonding configuration.)

Patchset is against net-next-2.6, but should apply to anything reasonably
recent with minimal fuzz.

Bill Nottingham (2):
  Add a 'bridging_masters' file in sysfs under class/net
  Add a 'interfaces' file to the bridge device configuration in sysfs

 net/bridge/br.c          |    2 +
 net/bridge/br_private.h  |    4 ++
 net/bridge/br_sysfs_br.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 0 deletions(-)

