Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYDWE7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYDWE7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbYDWE7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:59:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16696 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYDWE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YHf+YfM3MJHM+M7mjT37LKaI8irGrkvCXVsySxgUWNZp/sYwOktM/RU/l6WckvD5ZwfGvWVLZ7EA59rVWepkFc9pTyMMXhX8MQvJ726lJEEII3z9xxq6YcN9EoAr7zQQMuPvQAxlwoTg1su0MRX/5meaMyGExKv6Qs9HdUwJtk8=
Message-ID: <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
Date: Wed, 23 Apr 2008 08:59:22 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
	 <1208917076.9212.721.camel@pmac.infradead.org>
	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 8:18 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
> On Wed, Apr 23, 2008 at 6:17 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>  > On Fri, 2008-04-18 at 18:56 +0000, Linux Kernel Mailing List wrote:
>  >  > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
>  >  > Commit:     6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
>  >  > Parent:     6093015db2bd9e70cf20cdd23be1a50733baafdd
>  >  > Author:     gorcunov@gmail.com <gorcunov@gmail.com>
>  >  > AuthorDate: Fri Mar 28 17:56:57 2008 +0300
>  >  > Committer:  Ingo Molnar <mingo@elte.hu>
>  >  > CommitDate: Thu Apr 17 17:41:33 2008 +0200
>  >  >
>  >  >     x86: cleanup - rename VM_MASK to X86_VM_MASK
>  >  >
>  >  >     This patch renames VM_MASK to X86_VM_MASK (which
>  >  >     in turn defined as alias to X86_EFLAGS_VM) to better
>  >  >     distinguish from virtual memory flags. We can't just
>  >  >     use X86_EFLAGS_VM instead because it is also used
>  >  >     for conditional compilation
>  >  >
>  >  >     Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>  >  >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  >
>  >
>  >  > --- a/include/asm-x86/vm86.h
>  >  > +++ b/include/asm-x86/vm86.h
>  >  > @@ -17,9 +17,9 @@
>  >  >  #define IOPL_MASK    0x00003000
>  >  >  #define NT_MASK              0x00004000
>  >  >  #ifdef CONFIG_VM86
>  >  > -#define VM_MASK              0x00020000
>  >  > +#define X86_VM_MASK  X86_EFLAGS_VM
>  >  >  #else
>  >  > -#define VM_MASK              0 /* ignored */
>  >  > +#define X86_VM_MASK  0 /* No VM86 support */
>  >  >  #endif
>  >  >  #define AC_MASK              0x00040000
>  >  >  #define VIF_MASK     0x00080000      /* virtual interrupt flag */
>  >
>  >  This is user-visible. Yet we're changing the name and also making it
>  >  depend on #ifdef CONFIG_VM86, which is not going to be set in userspace.
>  >  Perhaps it should be within #ifdef __KERNEL__?
>  >
>  >  --
>  >  dwmw2
>  >
>  >
>
>  Thanks David, will check it today evening (i'm in office now)
>

Hi David,

actually, this CONFIG_VM86 was there even before the renaming was done.
The main questions (imo) - is there any user space application who uses
these flags? If they are - then even the idea of this patch was a bit bogus,
and I should *not* remove all these VM86 specific flags but better define them
as aliases on flags from processor-flags.h.

Ingo? Peter?
