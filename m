Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZD3Rh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZD3Rh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764689AbZD3RIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:31 -0400
Received: from kroah.org ([198.145.64.141]:56807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764662AbZD3RIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.115711217@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:55 -0700
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
       alan@lxorguk.ukuu.org.uk, Amit Shah <amit.shah@redhat.com>,
       mtosatti@redhat.com, avi@redhat.com
Subject: [patch 66/88] KVM: x86 emulator: Fix handling of VMMCALL instruction
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-emulator-fix-handling-of-vmmcall-instruction.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

(cherry picked from fbce554e940a983d005e29849636d0ef54b3eb18)

The VMMCALL instruction doesn't get recognised and isn't processed
by the emulator.

This is seen on an Intel host that tries to execute the VMMCALL
instruction after a guest live migrates from an AMD host.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -299,7 +299,7 @@ static u16 group_table[] = {
 
 static u16 group2_table[] = {
 	[Group7*8] =
-	SrcNone | ModRM, 0, 0, 0,
+	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
 };


