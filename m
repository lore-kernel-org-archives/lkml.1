Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZF3NA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZF3NA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZF3NAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:00:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:39413 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751886AbZF3NAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:00:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/KZ8ZGSBfKG0qV+ns1OMrDwJzCuJ1LNZNlrDSS4B
	sJ5kPUfztXTSLl
Subject: Re: [patch] x86: fix arch/x86/lib/clear_page_64.S::clear_page_c
 annotation
From: Mike Galbraith <efault@gmx.de>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <1246362139.20020.1322822615@webmail.messagingengine.com>
References: <1246359240.6103.34.camel@marge.simson.net>
	 <1246362139.20020.1322822615@webmail.messagingengine.com>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 15:00:20 +0200
Message-Id: <1246366820.6538.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 13:42 +0200, Alexander van Heukelum wrote:
> Hi Mike,
> 
> I agree with the code, but I do have a remark...
> 
> The ENTRY() macro already includes the ALIGN, so you could get
> rid of the preceding ALIGN. But it's just a neatness thing, because
> two consecutive ALIGNS don't change the resulting binary.
> 
> At any rate:
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> (maybe the x86-committer feels comfortable enough to remove the ALIGN ;)
> )

No doubt, but I can save him the trouble ;-)

x86: fix incorrect arch/x86/lib/clear_page_64.S::clear_page_c annotation.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <new-submission>

---
 arch/x86/lib/clear_page_64.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/lib/clear_page_64.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/clear_page_64.S
+++ linux-2.6/arch/x86/lib/clear_page_64.S
@@ -5,15 +5,14 @@
  * Zero a page. 	
  * rdi	page
  */			
-	ALIGN
-clear_page_c:
+ENTRY(clear_page_c)
 	CFI_STARTPROC
 	movl $4096/8,%ecx
 	xorl %eax,%eax
 	rep stosq
 	ret
 	CFI_ENDPROC
-ENDPROC(clear_page)
+ENDPROC(clear_page_c)
 
 ENTRY(clear_page)
 	CFI_STARTPROC


