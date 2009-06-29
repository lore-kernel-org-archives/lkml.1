Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZF2MJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZF2MJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZF2MJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:09:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58017 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZF2MJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:09:19 -0400
Date: Mon, 29 Jun 2009 15:08:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv3 0/4] kvm: locking and API rework for iosignalfd
Message-ID: <20090629120846.GA21273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series switches kvm_io_device to slots_lock from kvm->lock mutex,
and uses that to rework io bus API. This takes less locks on data path,
and uses less lines of code. These changes will also be useful to serve
as basis for Greg's iosignalfd work.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I have split the patch and reworked along the lines suggested by Avi.
This works for me, but please review carefully.

Michael S. Tsirkin (4):
  kvm: document locking for kvm_io_device_ops
  kvm: switch coalesced mmio changes to slots_lock
  kvm: convert bus to slots_lock
  kvm: remove in_range from io devices

 arch/ia64/kvm/kvm-ia64.c  |   28 +++--------
 arch/x86/kvm/i8254.c      |   53 +++++++++++----------
 arch/x86/kvm/i8259.c      |   22 +++++----
 arch/x86/kvm/lapic.c      |   44 ++++++++----------
 arch/x86/kvm/x86.c        |  110 +++++++++++++--------------------------------
 include/linux/kvm_host.h  |    9 +++-
 virt/kvm/coalesced_mmio.c |   28 +++++------
 virt/kvm/ioapic.c         |   24 +++++-----
 virt/kvm/iodev.h          |   42 +++++++----------
 virt/kvm/kvm_main.c       |   31 ++++++++-----
 10 files changed, 171 insertions(+), 220 deletions(-)
