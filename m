Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbYBRVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbYBRVxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYBRVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:53:10 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40940
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751538AbYBRVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:53:09 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Roland McGrath <roland@redhat.com>
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
Date: Mon, 18 Feb 2008 15:53:04 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802161727.21312.rob@landley.net> <200802180439.41928.rob@landley.net> <20080218184037.AAE87270196@magilla.localdomain>
In-Reply-To: <20080218184037.AAE87270196@magilla.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_B5fuH8mszyT6GeY"
Message-Id: <200802181553.05313.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_B5fuH8mszyT6GeY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 18 February 2008 12:40:37 Roland McGrath wrote:
> > I'm poking at it.  Something in my cross compiling setup is driving this
> > bit screwy:
> >
> >   i686-nm arch/x86/vdso/vdso32-sysenter.so.dbg |
>
> Show me the output of just this.

Attached.

> > sed -n -e 's/^00*/0/' -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$/ =
> > 0x;/p' | LC_ALL=C sort > arch/x86/vdso/vdso32-sysenter-syms.lds
>
> Also show me the vdso32-sysenter-syms.lds file.

Attached.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_B5fuH8mszyT6GeY
Content-Type: text/plain;
  charset="iso-8859-1";
  name="nm-out.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nm-out.txt"

0000000000000360 a _DYNAMIC
00000000000003d8 a _GLOBAL_OFFSET_TABLE_
000000000000040c T __kernel_rt_sigreturn
0000000000000400 T __kernel_sigreturn
0000000000000414 T __kernel_vsyscall
0000000000000000 A LINUX_2.5
0000000000000000 a VDSO32_PRELINK
000000000000040c t VDSO32_rt_sigreturn
0000000000000400 t VDSO32_sigreturn
0000000000000424 t VDSO32_SYSENTER_RETURN
0000000000000414 t VDSO32_vsyscall
0000000000000040 a VDSO32_vsyscall_eh_frame_size

--Boundary-00=_B5fuH8mszyT6GeY
Content-Type: text/plain;
  charset="iso-8859-1";
  name="vdso32-sysenter-syms.lds"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vdso32-sysenter-syms.lds"

VDSO32_PRELINK = 0x0;
VDSO32_SYSENTER_RETURN = 0x0424;
VDSO32_rt_sigreturn = 0x040c;
VDSO32_sigreturn = 0x0400;
VDSO32_vsyscall = 0x0414;
VDSO32_vsyscall_eh_frame_size = 0x040;

--Boundary-00=_B5fuH8mszyT6GeY--
