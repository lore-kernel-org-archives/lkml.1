Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXEaACG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXEaACG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXEaABz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:01:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbXEaABy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:01:54 -0400
Date: Wed, 30 May 2007 20:01:34 -0400
From: Dave Jones <davej@redhat.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH} x86_64 PM_TRACE support.
Message-ID: <20070531000133.GE2794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Richard Hughes <hughsient@gmail.com>,
	Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180161174.9773.60.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 04:32:54PM +1000, Nigel Cunningham wrote:

Hi Nigel,

 > As promised I took another look at the patch and at what Randy had
 > prepared to fix the IA64 compilation error. I did some more work on it,
 > and believe that the following is the tidiest correct solution I can
 > come up with. It differs from the version that caused the compilation
 > error primarily in that:
 > 
 > * the #include <asm/resume-trace.h> is inside the #ifdef 
 >   CONFIG_PM_TRACE.
 > * now-unnecessary protection for multiple #includes and ifdef testing of
 >   CONFIG_PM_TRACE in the asm code were removed.
 > * do-nothing definitions for !PM_TRACE restored to
 >   include/linux/resume-trace.h.
 > 
 > We're therefore depending upon kernel/power/Kconfig having the right
 > depends condition. As far as I can see, IA64 doesn't define CONFIG_X86.
 > Is that correct, or do we need to have (X86 && !IA64)?

Can you post a copy of this that isn't mangled by quoted-printable encoding?
Whilst it looks fine in my MUA, the diff ends up looking like..

diff -ruNp 200.patch-old/arch/x86_64/kernel/vmlinux.lds.S 200.patch-new/arc=
h/x86_64/kernel/vmlinux.lds.S
--- 200.patch-old/arch/x86_64/kernel/vmlinux.lds.S      2007-05-26 14:18:22.0000=
00000 +1000
+++ 200.patch-new/arch/x86_64/kernel/vmlinux.lds.S      2007-05-26 14:23:52.0000=
00000 +1000
@@ -52,6 +52,13 @@ SECTIONS
=20
   RODATA
=20
+  . =3D ALIGN(4);
+  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
+       __tracedata_start =3D .;
+       *(.tracedata)
+       __tracedata_end =3D .;
+  }


I'm beginning to think we really need a Documentation/Unhorking-MUAs-HOWTO
judging by the amount of broken encodings we seem to get to lkml these days.

	Dave

-- 
http://www.codemonkey.org.uk
