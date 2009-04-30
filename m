Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZD3RjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZD3RjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764666AbZD3RIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:34 -0400
Received: from kroah.org ([198.145.64.141]:56838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764611AbZD3RIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.557875301@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:58 -0700
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 69/88] KVM: MMU: check for present pdptr shadow page in walk_shadow
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-check-for-present-pdptr-shadow-page-in-walk_shadow.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------


(cherry picked from eb64f1e8cd5c3cae912db30a77d062367f7a11a6)

walk_shadow assumes the caller verified validity of the pdptr pointer in
question, which is not the case for the invlpg handler.

Fixes oops during Solaris 10 install.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1159,6 +1159,8 @@ static int walk_shadow(struct kvm_shadow
 	if (level == PT32E_ROOT_LEVEL) {
 		shadow_addr = vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
 		shadow_addr &= PT64_BASE_ADDR_MASK;
+		if (!shadow_addr)
+			return 1;
 		--level;
 	}
 


