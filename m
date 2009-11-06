Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZKFWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZKFWIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbZKFWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:57 -0500
Received: from kroah.org ([198.145.64.141]:39782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759944AbZKFWF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215952.485583618@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [19/30] KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID (CVE-2009-3638)
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=kvm-prevent-overflow-in-kvm_get_supported_cpuid-cve-2009-3638.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

commit 6a54435560efdab1a08f429a954df4d6c740bddf upstream.

The number of entries is multiplied by the entry size, which can
overflow on 32-bit hosts.  Bound the entry count instead.

Reported-by: David Wagner <daw@cs.berkeley.edu>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1591,6 +1591,8 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 
 	if (cpuid->nent < 1)
 		goto out;
+	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		cpuid->nent = KVM_MAX_CPUID_ENTRIES;
 	r = -ENOMEM;
 	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
 	if (!cpuid_entries)


