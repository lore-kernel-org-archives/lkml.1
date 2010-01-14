Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269Ab0ANVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0ANVxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903Ab0ANVxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:53:21 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:42954 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0ANVxU (ORCPT
	<rfc822;groupwise-PMullaney@novell.com:0:0>);
	Thu, 14 Jan 2010 16:53:20 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 0/3] vbus: venet macvlan rt netlink changes
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, arnd@arndb.de,
       netdev@vger.kernel.org
Date: Thu, 14 Jan 2010 16:52:55 -0500
Message-ID: <20100114215058.4958.87746.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to alacrityvm.git/master:a725f9950)

This series changes the venet macvlan device such that it can
be created via rt netlink and no longer requires any extensive
changes to the macvlan device itself. The first patch removes
prior changes to the macvlan device introduced in the alacrityvm
tree and also implements the changes needed for creation and
management via rt netlink. The subsequent patches(2 and 3) are
changes to the macvlan device for GRO support and for type
specific release. These 2 patches don't appear to be upstream.
If desired and approved, I'll regenerate these last 2 for
net-next.

---

Patrick Mullaney (3):
      macvlan: use rtnl_link_ops->dellink during unregister notications
      macvlan: add GRO bit to features mask
      venet-macvlan: allow rt netlink to create venet macvlan devices


 drivers/net/macvlan.c                   |   72 ++----
 include/linux/macvlan.h                 |    6 -
 kernel/vbus/devices/venet/device.c      |    8 +
 kernel/vbus/devices/venet/macvlan.c     |  360 ++++++++++++++++++++-----------
 kernel/vbus/devices/venet/tap.c         |    3 
 kernel/vbus/devices/venet/venetdevice.h |    3 
 6 files changed, 265 insertions(+), 187 deletions(-)

-- 
