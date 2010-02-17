Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab0BQNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934082Ab0BQNph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:37 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] KVM: Plan obsolescence of kernel allocated slots, paravirt mmu
Date: Wed, 17 Feb 2010 15:45:28 +0200
Message-Id: <1266414330-27444-19-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These features are unused by modern userspace and can go away.  Paravirt
mmu needs to stay a little longer for live migration.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 Documentation/feature-removal-schedule.txt |   30 ++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0a46833..47a6554 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -542,3 +542,33 @@ Why:	Duplicate functionality with the gspca_zc3xx driver, zc0301 only
 	sensors) wich are also supported by the gspca_zc3xx driver
 	(which supports 53 USB-ID's in total)
 Who:	Hans de Goede <hdegoede@redhat.com>
+
+----------------------------
+
+What:	KVM memory aliases support
+When:	July 2010
+Why:	Memory aliasing support is used for speeding up guest vga access
+	through the vga windows.
+
+	Modern userspace no longer uses this feature, so it's just bitrotted
+	code and can be removed with no impact.
+Who:	Avi Kivity <avi@redhat.com>
+
+----------------------------
+
+What:	KVM kernel-allocated memory slots
+When:	July 2010
+Why:	Since 2.6.25, kvm supports user-allocated memory slots, which are
+	much more flexible than kernel-allocated slots.  All current userspace
+	supports the newer interface and this code can be removed with no
+	impact.
+Who:	Avi Kivity <avi@redhat.com>
+
+----------------------------
+
+What:	KVM paravirt mmu host support
+When:	January 2011
+Why:	The paravirt mmu host support is slower than non-paravirt mmu, both
+	on newer and older hardware.  It is already not exposed to the guest,
+	and kept only for live migration purposes.
+Who:	Avi Kivity <avi@redhat.com>
-- 
1.6.5.3

