Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZCPMRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZCPMRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZCPMRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:17:36 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:33309 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCPMRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:17:35 -0400
Date: Mon, 16 Mar 2009 13:17:32 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090316121732.GC22978@cs.unibo.it>
References: <20090204080256.GC17452@cs.unibo.it> <20090310214456.GE5213@cs.unibo.it> <20090310220241.GC30475@elte.hu> <20090311134138.GD12753@cs.unibo.it> <20090316081508.GE3360@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316081508.GE3360@hack>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Cong,

Thank you for the detailed analysis of the code.
I'll change the code taking care of your observations asap.

On Mon, Mar 16, 2009 at 04:15:08PM +0800, Am??rico Wang wrote:
> >I have updated the patch, now it should be (more) consistent
> >with the Coding Style specifications.
> You can use scripts/checkpatch.pl to check it before sending.
I read the coding style document and I used the perl script.
However, the script is not able to cope with all the style specifications
and I may have missed something more. 
> 
> >UML tests at startup which features are provided and uses PTRACE_VM or
> >PTRACE_SYSEMU (or nothing). PTRACE_VM and/or PTRACE_SYSEMU support can be
> >disabled by command line flags.
> So what? PTRACE_VM is only supported in UML with this patch,
> UML still has to use PTRACE_SYSEMU on x86_32.
> 
> Am I missing something? :)
This patch [2/2] is for UML (host and guest). Patch #1 provides PTRACE_VM
for all the architectures supporting ptrace via tracehook.
By applying both patches PTRACE_VM is available in the following architectures:
x86*, sparc*, s390, powerpc*, ia64, sh* and um.
(I have not tested all these architectures, but the patch applies to the core ptrace
code, shared by all of them).
Ptrace_vm then provides the same speedup of PTRACE_SYSEMU extending its support:
- to other architectures: ports of UML or similar code for other architectures can
use it
- to other applications: PTRACE_SYSEMU supports the virtualization of all the system calls
while by PTRACE_VM the VM monitor can virtualize some of the system calls, depending on
some condition e.g. the value of a parameter. It is possible in this way give a faster
implementation to partial virtual machines like my umview.  

With patch #2 user-mode linux also uses ptrace_vm where available.

renzo
