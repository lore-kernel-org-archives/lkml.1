Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYKLVfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYKLVfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYKLVfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:35:05 -0500
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1037 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753694AbYKLVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:35:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 7137
Date: Wed, 12 Nov 2008 22:34:59 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
Message-ID: <20081112213459.GA2315@gentoox2.trippelsdorf.de>
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de> <20081112185617.4A1C71541FE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112185617.4A1C71541FE@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 10:56:17AM -0800, Roland McGrath wrote:
> Sorry for the delay, I've been offline.
> 
> > All of a sudden I get the following error when I build the kernel:
> 
> Suddenly when?  What changed to make this start happening?
> Is it recent kernel sources?  If so, can you git-bisect to
> which change did it?  If not, did something else change in
> your build environment that made this problem appear?
> Does it come or go with some .config change?
> 
> > --- -   2008-11-07 18:51:36.392997346 +0100
> > +++ arch/x86/vdso/vdso32-int80-syms.lds 2008-11-07 18:51:36.283820343 +0100
> > @@ -3,5 +3,3 @@
> >  VDSO32_sigreturn = 0x0400;
> >  VDSO32_vsyscall = 0x0420;
> >  VDSO32_vsyscall_eh_frame_size = 0x040;
> > -VDSO32_vsyscall = 0x0420;
> > -VDSO32_vsyscall_eh_frame_size = 0x040;
> > make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> > make: *** [arch/x86/vdso] Error 2
> 
> That sure looks odd.  It looks like sort -u failed to uniquify those lines.
> 
> Can you try something like this:
> 
> > -	else rm -f $(@D)/.tmp_$(@F); exit 1; \
> > +	else cat >&2 $(@D)/.tmp_$(@F); exit 1; \
> 
> and run make V=1 to see the full output on the failure?

Thanks for your reply.

Something odd is going on with my system:

% sort -u arch/x86/vdso/vdso32-int80-syms.lds arch/x86/vdso/vdso32-syscall-syms.lds arch/x86/vdso/vdso32-sysenter-syms.lds
VDSO32_PRELINK = 0x0;
VDSO32_rt_sigreturn = 0x0410;
VDSO32_sigreturn = 0x0400;
VDSO32_SYSENTER_RETURN = 0x0430;
VDSO32_vsyscall = 0x0420;
VDSO32_vsyscall_eh_frame_size = 0x040;

% LC_ALL=C sort -u arch/x86/vdso/vdso32-int80-syms.lds arch/x86/vdso/vdso32-syscall-syms.lds arch/x86/vdso/vdso32-sysenter-syms.lds
VDSO32_PRELINK = 0x0;
VDSO32_SYSENTER_RETURN = 0x0430;
VDSO32_rt_sigreturn = 0x0410;
VDSO32_sigreturn = 0x0400;
VDSO32_vsyscall = 0x0420;
VDSO32_vsyscall_eh_frame_size = 0x040;
VDSO32_vsyscall = 0x0420;
VDSO32_vsyscall_eh_frame_size = 0x040;

I will try to figure out what causes this behaviour, but it is not
kernel related I guess. So I apologize for the noise.

-- 
Markus
