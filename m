Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZF2TYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZF2TYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZF2TYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:24:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZF2TYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:24:33 -0400
Date: Mon, 29 Jun 2009 22:23:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv5 0/6] kvm: locking and API rework for iosignalfd
Message-ID: <20090629192358.GA27464@redhat.com>
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

This works for me, but please review carefully.

Changes since v4:
	Typo fix

Changes since v3:
	Fix bug noticed by Marcelo
	Switch pit creation to slots_lock
	Add unlocked variant for bus changes: in use by pit
	More documentation

Changes since v2:
	I have split the patch and reworked along the lines suggested by Avi.

Michael S. Tsirkin (6):
  kvm: document locking for kvm_io_device_ops
  kvm: switch coalesced mmio changes to slots_lock
  kvm: switch pit creation to slots_lock
  kvm: convert bus to slots_lock
  kvm: remove in_range from io devices
  kvm: document lock nesting rule

 arch/ia64/kvm/kvm-ia64.c  |   28 +++--------
 arch/x86/kvm/i8254.c      |   54 +++++++++++----------
 arch/x86/kvm/i8259.c      |   22 +++++----
 arch/x86/kvm/lapic.c      |   44 ++++++++---------
 arch/x86/kvm/x86.c        |  114 +++++++++++++-------------------------------
 include/linux/kvm_host.h  |   11 +++-
 virt/kvm/coalesced_mmio.c |   28 +++++------
 virt/kvm/ioapic.c         |   24 +++++----
 virt/kvm/iodev.h          |   42 +++++++---------
 virt/kvm/kvm_main.c       |   38 +++++++++++----
 10 files changed, 183 insertions(+), 222 deletions(-)
