Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbZD3RlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbZD3RlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764712AbZD3RIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:38 -0400
Received: from kroah.org ([198.145.64.141]:56881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764677AbZD3RIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:49 2009
Message-Id: <20090430165749.163298759@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
       mtosatti@redhat.com, avi@redhat.com
Subject: [patch 73/88] KVM: x86: disable kvmclock on non constant TSC hosts
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-disable-kvmclock-on-non-constant-tsc-hosts.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------


(cherry picked from abe6655dd699069b53bcccbc65b2717f60203b12)

This is better.

Currently, this code path is posing us big troubles,
and we won't have a decent patch in time. So, temporarily
disable it.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -906,7 +906,6 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
-	case KVM_CAP_CLOCKSOURCE:
 	case KVM_CAP_PIT:
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
@@ -931,6 +930,9 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_IOMMU:
 		r = intel_iommu_found();
 		break;
+	case KVM_CAP_CLOCKSOURCE:
+		r = boot_cpu_has(X86_FEATURE_CONSTANT_TSC);
+		break;
 	default:
 		r = 0;
 		break;


