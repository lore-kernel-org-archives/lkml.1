Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935670Ab0BZJWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:22:25 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:52439 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935659Ab0BZJWX (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 26 Feb 2010 04:22:23 -0500
Message-Id: <4B87A0DD0200007800031733@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Feb 2010 09:22:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <justinmattock@gmail.com>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix placement of FIX_OHCI1394_BASE
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartEBC12ADD.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartEBC12ADD.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ever for 32-bit with sufficiently high NR_CPUS, and starting with
commit 789d03f584484af85dbdc64935270c8e45f36ef7 also for 64-bit, the
statically allocated early fixmap page tables were not covering
FIX_OHCI1394_BASE, leading to a boot time crash when
"ohci1394_dma=3Dearly" was used. Despite this entry not being a
permanently used one, it needs to be moved into the permanent range
since it has to be close to FIX_DBGP_BASE and FIX_EARLYCON_MEM_BASE.

(A patch version applying to -tip is attached.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>
Fixes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=3D14487=20
Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com=
>

---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.33/arch/x86/include/asm/fixmap.h	2009-12-03 04:51:21.0000000=
00 +0100
+++ 2.6.33-ohci1394-fixmap/arch/x86/include/asm/fixmap.h	2010-02-26 =
00:00:00.000000000 +0100
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -126,9 +129,6 @@ enum fixed_addresses {
 	FIX_BTMAP_END =3D __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN =3D FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS =
- 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif




--=__PartEBC12ADD.4__=
Content-Type: text/plain; name="linux-tip-ohci1394-fixmap.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-tip-ohci1394-fixmap.patch"

Ever for 32-bit with sufficiently high NR_CPUS, and starting with=0Acommit =
789d03f584484af85dbdc64935270c8e45f36ef7 also for 64-bit, the=0Astatically =
allocated early fixmap page tables were not covering=0AFIX_OHCI1394_BASE, =
leading to a boot time crash when=0A"ohci1394_dma=3Dearly" was used. =
Despite this entry not being a=0Apermanently used one, it needs to be =
moved into the permanent range=0Asince it has to be close to FIX_DBGP_BASE =
and FIX_EARLYCON_MEM_BASE.=0A=0ASigned-off-by: Jan Beulich <jbeulich@novell=
.com>=0ACc: <stable@kernel.org>=0AFixes-bug: http://bugzilla.kernel.org/sho=
w_bug.cgi?id=3D14487=0AReported-bisected-and-tested-by: Justin P. Mattock =
<justinmattock@gmail.com>=0A=0A---=0A arch/x86/include/asm/fixmap.h |    6 =
+++---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=0A--- =
a/arch/x86/include/asm/fixmap.h=0A+++ b/arch/x86/include/asm/fixmap.h=0A@@ =
-82,6 +82,9 @@ enum fixed_addresses {=0A #endif=0A 	FIX_DBGP_BASE,=0A 	=
FIX_EARLYCON_MEM_BASE,=0A+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT=0A+	=
FIX_OHCI1394_BASE,=0A+#endif=0A #ifdef CONFIG_X86_LOCAL_APIC=0A 	=
FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */=0A =
#endif=0A@@ -132,9 +135,6 @@ enum fixed_addresses {=0A 	   (__end_of_perman=
ent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))=0A 	 : __end_of_permane=
nt_fixed_addresses,=0A 	FIX_BTMAP_BEGIN =3D FIX_BTMAP_END + TOTAL_FIX_BTMAP=
S - 1,=0A-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT=0A-	FIX_OHCI1394_BASE,=
=0A-#endif=0A #ifdef CONFIG_X86_32=0A 	FIX_WP_TEST,=0A #endif=0A
--=__PartEBC12ADD.4__=--
