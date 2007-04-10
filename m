Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXDJMu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXDJMu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXDJMu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:50:58 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48817 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXDJMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:50:57 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: [PATCH] Build break on ppc64 for 2.6.21-rc6-mm1
Date: Tue, 10 Apr 2007 18:20:47 +0530
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ng4GGemdXD+cSQz"
Message-Id: <200704101820.47509.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ng4GGemdXD+cSQz
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


When I tried to compile 2.6.21-rc6-mm1 on ppc64, I got the below error=20
message.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
arch/powerpc/sysdev/timer.c:51: error: variable =E2=80=98timer_sysclass=E2=
=80=99 has=20
initializer but incomplete type
arch/powerpc/sysdev/timer.c:52: error: unknown field =E2=80=98resume=E2=80=
=99 specified in=20
initializer
arch/powerpc/sysdev/timer.c:52: warning: excess elements in struct initiali=
zer
arch/powerpc/sysdev/timer.c:52: warning: (near initialization=20
for =E2=80=98timer_sysclass=E2=80=99)
arch/powerpc/sysdev/timer.c:53: error: unknown field =E2=80=98suspend=E2=80=
=99 specified in=20
initializer
arch/powerpc/sysdev/timer.c:53: warning: excess elements in struct initiali=
zer
arch/powerpc/sysdev/timer.c:53: warning: (near initialization=20
for =E2=80=98timer_sysclass=E2=80=99)
arch/powerpc/sysdev/timer.c:54: error: unknown field =E2=80=98kset=E2=80=99=
 specified in=20
initializer
arch/powerpc/sysdev/timer.c:54: error: extra brace group at end of initiali=
zer
arch/powerpc/sysdev/timer.c:54: error: (near initialization=20
for =E2=80=98timer_sysclass=E2=80=99)
arch/powerpc/sysdev/timer.c:54: error: extra brace group at end of initiali=
zer
arch/powerpc/sysdev/timer.c:54: error: (near initialization=20
for =E2=80=98timer_sysclass=E2=80=99)
arch/powerpc/sysdev/timer.c:54: warning: excess elements in struct initiali=
zer
arch/powerpc/sysdev/timer.c:54: warning: (near initialization=20
for =E2=80=98timer_sysclass=E2=80=99)
arch/powerpc/sysdev/timer.c:57: error: variable =E2=80=98device_timer=E2=80=
=99 has initializer=20
but incomplete type
arch/powerpc/sysdev/timer.c:58: error: unknown field =E2=80=98id=E2=80=99 s=
pecified in=20
initializer
arch/powerpc/sysdev/timer.c:58: warning: excess elements in struct initiali=
zer
arch/powerpc/sysdev/timer.c:58: warning: (near initialization=20
for =E2=80=98device_timer=E2=80=99)
arch/powerpc/sysdev/timer.c:59: error: unknown field =E2=80=98cls=E2=80=99 =
specified in=20
initializer
arch/powerpc/sysdev/timer.c:59: warning: excess elements in struct initiali=
zer
arch/powerpc/sysdev/timer.c:59: warning: (near initialization=20
for =E2=80=98device_timer=E2=80=99)
arch/powerpc/sysdev/timer.c: In function =E2=80=98time_init_device=E2=80=99:
arch/powerpc/sysdev/timer.c:64: warning: implicit declaration of=20
function =E2=80=98sysdev_class_register=E2=80=99
arch/powerpc/sysdev/timer.c:66: warning: implicit declaration of=20
function =E2=80=98sysdev_register=E2=80=99
make[1]: *** [arch/powerpc/sysdev/timer.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Below patch fixes this problem. please let me know comments on this.

Signed-off-by: Srinivasa Ds <srinivasa@in.ibm.com>


--Boundary-00=_ng4GGemdXD+cSQz
Content-Type: text/x-diff;
  charset="utf-8";
  name="build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="build.patch"

---
 arch/powerpc/sysdev/timer.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc6/arch/powerpc/sysdev/timer.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/powerpc/sysdev/timer.c
+++ linux-2.6.21-rc6/arch/powerpc/sysdev/timer.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/sysdev.h>
 #include <asm/rtc.h>
 
 static unsigned long suspend_rtc_time;

--Boundary-00=_ng4GGemdXD+cSQz--
