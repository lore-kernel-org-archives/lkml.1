Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYHFNZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYHFNZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYHFNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:25:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:47860 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753649AbYHFNZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:25:30 -0400
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX19tVv8/Etxtgqaml1TSGIVwqhxq41/n6Ucnp6pvAI
	1ZoREynBgBi8nK
Message-ID: <4899A646.20205@gmx.de>
Date: Wed, 06 Aug 2008 15:25:26 +0200
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] x86: fix comment in protected mode header
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Kohlbecher <xt28@gmx.de>

Comments in arch/x86/boot/compressed/head_32.S erroneously refer to the 
real mode pointer as the second and the heap area as the third argument 
to decompress_kernel(). In fact, these have been the first and second 
argument, respectively, since v2.6.20.

This patch corrects the comments. It introduces no code changes.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

---

Please CC me, I am not on the list.

  arch/x86/boot/compressed/head_32.S |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S 
b/arch/x86/boot/compressed/head_32.S
index ba7736c..29c5fbf 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -137,14 +137,15 @@ relocated:
   */
  	movl output_len(%ebx), %eax
  	pushl %eax
+			# push arguments for decompress_kernel:
  	pushl %ebp	# output address
  	movl input_len(%ebx), %eax
  	pushl %eax	# input_len
  	leal input_data(%ebx), %eax
  	pushl %eax	# input_data
  	leal boot_heap(%ebx), %eax
-	pushl %eax	# heap area as third argument
+	pushl %eax	# heap area
-	pushl %esi	# real mode pointer as second arg
+	pushl %esi	# real mode pointer
  	call decompress_kernel
  	addl $20, %esp
  	popl %ecx

