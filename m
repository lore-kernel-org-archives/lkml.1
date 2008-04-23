Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYDWESm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYDWESm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYDWESb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:18:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:25617 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYDWESb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XZ409ksgggQigB/MO02JP+5OhdpbS3WD+CAgst2JnzhXuZH3n7zFIRjMLsVby3RZ167bQANZ0+2N+kbGPfmpCUo8hZoS05MiI4C/KOZya/loOxY2sjhxsxFNJWL2cHXI9GoVXSU1sl65PLlKH836UBti6UwSPm2oHjbBkU75ckc=
Message-ID: <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
Date: Wed, 23 Apr 2008 08:18:30 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1208917076.9212.721.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
	 <1208917076.9212.721.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 6:17 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2008-04-18 at 18:56 +0000, Linux Kernel Mailing List wrote:
>  > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
>  > Commit:     6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
>  > Parent:     6093015db2bd9e70cf20cdd23be1a50733baafdd
>  > Author:     gorcunov@gmail.com <gorcunov@gmail.com>
>  > AuthorDate: Fri Mar 28 17:56:57 2008 +0300
>  > Committer:  Ingo Molnar <mingo@elte.hu>
>  > CommitDate: Thu Apr 17 17:41:33 2008 +0200
>  >
>  >     x86: cleanup - rename VM_MASK to X86_VM_MASK
>  >
>  >     This patch renames VM_MASK to X86_VM_MASK (which
>  >     in turn defined as alias to X86_EFLAGS_VM) to better
>  >     distinguish from virtual memory flags. We can't just
>  >     use X86_EFLAGS_VM instead because it is also used
>  >     for conditional compilation
>  >
>  >     Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>  >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
>  > --- a/include/asm-x86/vm86.h
>  > +++ b/include/asm-x86/vm86.h
>  > @@ -17,9 +17,9 @@
>  >  #define IOPL_MASK    0x00003000
>  >  #define NT_MASK              0x00004000
>  >  #ifdef CONFIG_VM86
>  > -#define VM_MASK              0x00020000
>  > +#define X86_VM_MASK  X86_EFLAGS_VM
>  >  #else
>  > -#define VM_MASK              0 /* ignored */
>  > +#define X86_VM_MASK  0 /* No VM86 support */
>  >  #endif
>  >  #define AC_MASK              0x00040000
>  >  #define VIF_MASK     0x00080000      /* virtual interrupt flag */
>
>  This is user-visible. Yet we're changing the name and also making it
>  depend on #ifdef CONFIG_VM86, which is not going to be set in userspace.
>  Perhaps it should be within #ifdef __KERNEL__?
>
>  --
>  dwmw2
>
>

Thanks David, will check it today evening (i'm in office now)
