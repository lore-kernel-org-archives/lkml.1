Return-Path: <linux-kernel-owner+w=401wt.eu-S1763253AbXLMHEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763253AbXLMHEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbXLMG4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778AbXLMG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:31 -0500
Date: Wed, 12 Dec 2007 22:52:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm-devel@lists.sourceforge.net, Amit Shah <amit.shah@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 21/60] KVM: x86 emulator: Use emulator_write_emulated and
	not emulator_write_std
Message-ID: <20071213065201.GV6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-x86-emulator-use-emulator_write_emulated-and-not-emulator_write_std.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Amit Shah <amit.shah@qumranet.com>

patch 00b2ef475d4728ca53a2bc788c7978042907e354 in mainline.

emulator_write_std() is not implemented, and calling write_emulated should
work just as well in place of write_std.

Fixes emulator failures with the push r/m instruction.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/x86_emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1066,7 +1066,7 @@ done_prefixes:
 			}
 			register_address_increment(_regs[VCPU_REGS_RSP],
 						   -dst.bytes);
-			if ((rc = ops->write_std(
+			if ((rc = ops->write_emulated(
 				     register_address(ctxt->ss_base,
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt)) != 0)

-- 
