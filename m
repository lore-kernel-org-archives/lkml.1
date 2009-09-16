Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZIPWpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZIPWpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbZIPWoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:44:24 -0400
Received: from kroah.org ([198.145.64.141]:55377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760378AbZIPWkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:18 2009
Message-Id: <20090916223718.130918299@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@redhat.com>
Subject: [patch 33/45] KVM: Fix coalesced interrupt reporting in IOAPIC
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-coalesced-interrupt-reporting-in-ioapic.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gleb Natapov <gleb@redhat.com>

commit 65a82211636f156a276cac3f8665605ae18f371f upstream.

This bug was introduced by b4a2f5e723e4f7df467.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/ioapic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -188,6 +188,8 @@ int kvm_ioapic_set_irq(struct kvm_ioapic
 			if ((edge && old_irr != ioapic->irr) ||
 			    (!edge && !entry.fields.remote_irr))
 				ret = ioapic_service(ioapic, irq);
+			else
+				ret = 0; /* report coalesced interrupt */
 		}
 	}
 	return ret;


