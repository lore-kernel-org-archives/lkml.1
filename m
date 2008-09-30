Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYI3Ti1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYI3Ti1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYI3TiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:38:19 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:7202 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYI3TiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:38:18 -0400
Date: Tue, 30 Sep 2008 21:37:36 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] fix: x86: remove cpu_vendor_dev
Message-ID: <20080930193736.GA4453@mailshack.com>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 30 Sep 2008 21:38:02 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64-kernels after commit 10a434fcb "x86: remove cpu_vendor_dev"
crashed on qemu-system-x86_64 due to a typo in vmlinux_64.lds.S.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Tue, Sep 30, 2008 at 06:41:33PM +0200, Alexander van Heukelum wrote:
> Moreover, a defconfig won't run :-/ (on qemu-system-x86_64).
> Bisection pointed to commit 10a434fcb "x86: remove cpu_vendor_dev".
> The kernel crashes early with a general protection fault in a call
> to strnlen. I have no idea what goes wrong, yet.

It took quite some time, but I found the problem... I'll leave
the other one to you ;).

Greetings,
	Alexander

 arch/x86/kernel/vmlinux_64.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 201e81a..46e0544 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -172,8 +172,8 @@ SECTIONS
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 	*(.x86_cpu_dev.init)
   }
-  SECURITY_INIT
   __x86_cpu_dev_end = .;
+  SECURITY_INIT
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
