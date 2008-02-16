Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYBPXse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYBPXse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 18:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYBPXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 18:48:12 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46870
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752775AbYBPXsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 18:48:11 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
Date: Sat, 16 Feb 2008 17:27:21 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802161727.21312.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anybody else having trouble compiling the kernel with binutils 2.17?

The build does this:
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
> --- -   Fri Feb 15 23:38:41 2008
> +++ arch/x86/vdso/vdso32-int80-syms.lds Fri Feb 15 23:38:41 2008
> @@ -0,0 +1,5 @@
> +VDSO32_PRELINK = 0x0;
> +VDSO32_rt_sigreturn = 0x040c;
> +VDSO32_sigreturn = 0x0400;
> +VDSO32_vsyscall = 0x0414;
> +VDSO32_vsyscall_eh_frame_size = 0x040;
> make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> make: *** [arch/x86/vdso] Error 2
> make: *** Waiting for unfinished jobs....

Still trying to track down why, but it works on a toolchain built from 
binutils 2.18 and gcc 4.1.3, but not with a toolchain from binutils 2.17 and 
gcc 4.1.2.  And considering where it's failing...

If binutils 2.18 is the only version that now builds the kernel, could we 
update Documentaiton/Changes to say that instead of 2.12?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
