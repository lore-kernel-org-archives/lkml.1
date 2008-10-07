Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYJGAub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYJGAub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbYJGAn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:46804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbYJGAnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:55 -0400
Date: Mon, 6 Oct 2008 17:38:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
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
       alan@lxorguk.ukuu.org.uk, Glauber de Oliveira Costa <glommer@gmail.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>
Subject: [patch 27/71] x86: Fix 27-rc crash on vsmp due to paravirt during
	module load
Message-ID: <20081007003836.GB3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-27-rc-crash-on-vsmp-due-to-paravirt-during-module-load.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ravikiran Thirumalai <kiran@scalex86.org>

commit 05e12e1c4c09cd35ac9f4e6af1e42b0036375d72 upstream.

vsmp_patch has been marked with __init ever since pvops, however,
apply_paravirt can be called during module load causing calls to
freed memory location.

Since apply_paravirt can only be called during bootup and module load,
mark vsmp patch with "__init_or_module"

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vsmp_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -58,7 +58,7 @@ static void vsmp_irq_enable(void)
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {

-- 
