Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXHUG6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXHUG6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbXHUGzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:55:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44308 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761458AbXHUGy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:54:58 -0400
Date: Mon, 20 Aug 2007 23:55:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jbeulich@novell.com,
       patches@x86-64.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/20] i386: allow debuggers to access the vsyscall page
	with compat vDSO
Message-ID: <20070821065543.GP5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-allow-debuggers-to-access-the-vsyscall-page-with-compat-vdso.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Beulich <jbeulich@novell.com>


From: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/sysenter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -336,7 +336,9 @@ struct vm_area_struct *get_gate_vma(stru
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)

-- 
