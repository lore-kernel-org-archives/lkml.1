Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYEJUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYEJUdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYEJUdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:33:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:58372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbYEJUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aCj4TDbOybuFrSL8N3i+fZPdhCR/N2yJhWUNdujeC5Tlu5fDiTNjSXpyNfVw55XsaPiEqJL447Gznz8xnEJifhpxVTURrMf2BVjaKxNrRMEOR+u6b/1tLj0h3XittusX7WQDj/YNbRCbX5KpgJ83gBHmRHVytKuG6z1hoWSH3Y4=
Message-ID: <6101e8c40805101333l582aecebr3dd49d5d30f9efc@mail.gmail.com>
Date: Sat, 10 May 2008 22:33:09 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Aurelien Jarno" <aurelien@aurel32.net>
Subject: [2.6.24] [Q] x86: clear DF before calling signal handler II.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML!

Im mainline e40cd10ccff3d9fbffd57b93780bee4b7b9bff51 commit
( x86: clear DF before calling signal handler ) changed the ~TF_MASK and
~X86_EFLAGS_TF to ~(~X86_EFLAGS_TF | ~X86_EFLAGS_DF).

 include/asm-x86/signal.h:
-------------------------->
 248 #define ptrace_signal_deliver(regs, cookie)             \
 249         do {                                            \
 250                 if (current->ptrace & PT_DTRACE) {      \
 251                         current->ptrace &= ~PT_DTRACE;  \
 252                         (regs)->eflags &= ~TF_MASK;     \ <-----------
 253                 }                                       \
 254         } while (0)
<-------------------------

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

the question:
in this file the change is unnecessary or forgotted?

NO COMPILE TESTED!

---

diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index 987a422..71effa1 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -249,7 +249,7 @@ struct pt_regs;
        do {                                            \
                if (current->ptrace & PT_DTRACE) {      \
                        current->ptrace &= ~PT_DTRACE;  \
-                       (regs)->eflags &= ~TF_MASK;     \
+                       (regs)->eflags &= ~(TF_MASK | X86_EFLAGS_DF);   \
                }                                       \
        } while (0)



-- 
Thanks,
Oliver
