Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0BJLsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:48:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:5405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0BJLsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:48:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,443,1262592000"; 
   d="scan'208";a="771682880"
From: Xin Xiaohui <xiaohui.xin@intel.com>
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org
Subject: [PATCH 0/3] Provide a zero-copy method on KVM virtio-net.
Date: Wed, 10 Feb 2010 19:48:57 +0800
Message-Id: <1265802540-6122-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is simple, just to pin the guest VM user space and then
let host NIC driver has the chance to directly DMA to it. 
The patches are based on vhost-net backend driver. We add a device
which provides proto_ops as sendmsg/recvmsg to vhost-net to
send/recv directly to/from the NIC driver. KVM guest who use the
vhost-net backend may bind any ethX interface in the host side to
get copyless data transfer thru guest virtio-net frontend.

We provide multiple submits and asynchronous notifiicaton to 
vhost-net too.

Our goal is to improve the bandwidth and reduce the CPU usage.
Exact performance data will be provided later. But for simple
test with netperf, we found bindwidth up and CPU % up too,
but the bindwidth up ratio is much more than CPU % up ratio.

What we have not done yet:
	To support GRO
	Performance tuning
