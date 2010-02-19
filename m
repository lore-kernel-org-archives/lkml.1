Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0BSRLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:11:50 -0500
Received: from kroah.org ([198.145.64.141]:57583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab0BSRAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:40 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:42 2010
Message-Id: <20100219163242.731197807@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [43/93] KVM: PIT: control word is write-only
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit ee73f656a604d5aa9df86a97102e4e462dd79924 upstream.

PIT control word (address 0x43) is write-only, reads are undefined.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/i8254.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -465,6 +465,9 @@ static int pit_ioport_read(struct kvm_io
 		return -EOPNOTSUPP;
 
 	addr &= KVM_PIT_CHANNEL_MASK;
+	if (addr == 3)
+		return 0;
+
 	s = &pit_state->channels[addr];
 
 	mutex_lock(&pit_state->lock);


