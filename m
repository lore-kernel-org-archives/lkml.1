Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbZJIXRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbZJIXRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbZJIXRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:33 -0400
Received: from kroah.org ([198.145.64.141]:36844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761661AbZJIXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.148004287@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 16/26] KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=kvm-prevent-overflow-in-kvm_get_supported_cpuid.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

commit 6a54435560efdab1a08f429a954df4d6c740bddf upstream.

The number of entries is multiplied by the entry size, which can
overflow on 32-bit hosts.  Bound the entry count instead.

Reported-by: David Wagner <daw@cs.berkeley.edu>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1429,6 +1429,8 @@ static int kvm_dev_ioctl_get_supported_c
 
 	if (cpuid->nent < 1)
 		goto out;
+	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		cpuid->nent = KVM_MAX_CPUID_ENTRIES;
 	r = -ENOMEM;
 	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
 	if (!cpuid_entries)


