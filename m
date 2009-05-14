Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbZENW5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbZENW5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZENWmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:53 -0400
Received: from kroah.org ([198.145.64.141]:52658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbZENWme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:27 2009
Message-Id: <20090514223527.514350123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:18 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>
Subject: [patch 43/51] KVM: SVM: Remove port 80 passthrough
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-remove-port-80-passthrough.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 99f85a28a78e96d28907fe036e1671a218fee597 upstream.

KVM optimizes guest port 80 accesses by passthing them through to the host.
Some AMD machines die on port 80 writes, allowing the guest to hard-lock the
host.

Remove the port passthrough to avoid the problem.

Reported-by: Piotr Jaroszyński <p.jaroszynski@gmail.com>
Tested-by: Piotr Jaroszyński <p.jaroszynski@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -411,7 +411,6 @@ static __init int svm_hardware_setup(voi
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
-	clear_bit(0x80, iopm_va); /* allow direct access to PC debug port */
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 	if (boot_cpu_has(X86_FEATURE_NX))


