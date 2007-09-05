Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXIENtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXIENtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXIENtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:49:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:33693 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbXIENta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=AC/V771nJpYVxDZAG7o2U6n9Ps7eZq+Kb4496cYtR7/Hf+geauBlNnPjj4y55aHmaUDtxRI8lBrDNctFz8Hx1Xnu+YwwpnfnCyjNJgZ4IfBYqozZ0QXr94KKvMNJXTafkDwClWnvKTJYW6C/5ZrVoYPj0sRpakvP6kGlBpHHPgw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: sam@ravnborg.org
Subject: [PATCH 2/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 14:49:22 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com>
In-Reply-To: <200709051447.00774.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iPr3G+hulxhbJKM"
Message-Id: <200709051449.22567.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_iPr3G+hulxhbJKM
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 05 September 2007 14:47, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > These patches fix section names and add
> > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > unconditionally because only newest binutils have
> > ld --gc-sections which is stable enough for kernel use.
> > IOW: this is an experimental feature for now.
> 
> Part 1: fix section names over entire source (all arches).

Part 2: fix x86_64 vdso linker script to not produce
broken vdso image with gcc -ffunction-sections -fdata-sections.

Does not affect normal build.
--
vda

--Boundary-00=_iPr3G+hulxhbJKM
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.2.vdso.lds.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.2.vdso.lds.patch"

--- linux-2.6.23-rc4.gc1/arch/x86_64/vdso/vdso.lds.S	Tue Sep  4 21:48:52 2007
+++ linux-2.6.23-rc4.gc2/arch/x86_64/vdso/vdso.lds.S	Tue Sep  4 21:49:17 2007
@@ -26,11 +26,11 @@
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
 
-  .text           : { *(.text) }		:text
+  .text           : { *(.text) *(.text.*) }	:text
   .text_ptr       : { *(.text_ptr) }		:text
   . = VDSO_PRELINK + 0x900;
-  .data           : { *(.data) }		:text
-  .bss            : { *(.bss) }			:text
+  .data           : { *(.data) *(.data.*) }	:text
+  .bss            : { *(.bss) *(.bss.*) }	:text
 
   .altinstructions : { *(.altinstructions) }			:text
   .altinstr_replacement  : { *(.altinstr_replacement) }	:text

--Boundary-00=_iPr3G+hulxhbJKM--
