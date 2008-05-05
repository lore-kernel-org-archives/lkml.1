Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYEEMpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYEEMpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYEEMpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:45:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:61407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYEEMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wfQ9fmOKzjlfRArt9FKqYXv4Fda1JM6pBErPMkbgt1+jhyWbMZTyUQldrRrOb2ZIPhzUWl8SwCrZ5n/yhKOIzGnloNQC3ysOmFjRQjHX/X7nrFhTzlxFDV0Q8HNVwqlorSjfBzPMa+Q9ygG1/8hACW7SnQsBhi85EcUyseHaD7c=
Message-ID: <517f3f820805050545k661e2878j8ef43cc8b2fe9726@mail.gmail.com>
Date: Mon, 5 May 2008 14:45:42 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: ptrace PTRACE_PEEKUSER behavior
Cc: Anoop <acv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       roland@redhat.com, mtk.manpages@googlemail.com
In-Reply-To: <87hcddc6e7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com>
	 <87hcddc6e7.fsf@basil.nowhere.org>
X-Google-Sender-Auth: d9b00ffb3713f4e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/08, Andi Kleen <andi@firstfloor.org> wrote:
> Anoop <acv@linux.vnet.ibm.com> writes:
>
>  [intentional fullquote]
>
>
>  > The call ptrace(PTRACE_PEEKUSER, <pid>, ...) does not work as described in the
>  > man page.
>  >
>  > Specifically, the man page states:
>  > PTRACE_PEEKUSER
>  >       Reads a word at offset addr in the child's USER area, which
>  >       holds the registers and other information about the process (see
>  >       <linux/user.h> and <sys/user.h>). The word is returned as the
>  >       result of the ptrace() call. Typically the offset must be word-
>  >       aligned, though this might vary by architecture. (data is
>  >       ignored.)
>  >
>  > Using the PTRACE_PEEKUSER action, the "regs" component can be read, but the
>  > values past regs are not obtained. Even the reg values are not
>  > retrieved from a
>  > 'user' structure, but from the 'task_struct' of the process.
>  >
>  > linux-2.6.26-rc1/include/asm-x86/user_32.h defines struct user like this.
>
>  [..]
>  >
>  > /* When the kernel dumps core, it starts by dumping the user struct -
>
>
> [..]
>
> >       */
>  >       /* ptrace does not yet supply these. Someday.... */ <===================
>
> >       /* for this mess. Not yet used. */
>  >       struct user_i387_struct i387; /* Math Co-processor registers. */
>  >       /* The rest of this junk is to help gdb figure out what goes where */
>  >       unsigned long int u_tsize; /* Text segment size (pages). */
>  >       unsigned long int u_dsize; /* Data segment size (pages). */
>  >       unsigned long int u_ssize; /* Stack segment size (pages). */
>  >       unsigned long start_code; /* Starting virtual address of text. */
>  >       unsigned long start_stack; /* Starting virtual address of stack area.
>  >       This is actually the bottom of the stack, the top of the stack is always
>  >       found in the    esp register. */
>  >       long int signal; /* Signal that caused the core dump. */
>  >       int reserved; /* No longer used */
>  >       struct user_pt_regs * u_ar0; /* Used by gdb to help find the values for */
>  >       /* the registers. */
>  >       struct user_i387_struct* u_fpstate; /* Math Co-processor pointer. */
>  >       unsigned long magic; /* To uniquely identify a core file */
>  >       char u_comm[32]; /* User command that was responsible */
>  >       int u_debugreg[8];
>  > };
>  >
>  > Noting the comment after 'struct user_regs_struct regs', is there any specific
>  > reason why ptrace doesn't provide the rest of the members of this
>  > structure?
>
>
> Since Linux internally has no "struct user" all of this has to be
>  implemented by special case code (in particularly a big switch statement)
>  While that could be done if nobody uses it (and that seems
>  to be the case) it would be just a waste of code.
>
>
>  > In
>  > that case shouldn't the man pages be corrected?
>
>
> Probably. cc mtk.

Anoop would you be able to write a patch for the the man page?  (Yoou
can get the latest page in a tarball at the location below.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
