Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYGKLR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYGKLR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYGKLRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:17:17 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45955 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYGKLRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:17:16 -0400
Date: Fri, 11 Jul 2008 12:15:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: pageexec@freemail.hu
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ollie Wild <aaw@google.com>,
       bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 11063][PATCH] exec: fix stack excutability without PT_GNU_STACK
In-Reply-To: <4876997B.15434.250C736@pageexec.freemail.hu>
Message-ID: <Pine.LNX.4.64.0807111203140.19456@blonde.site>
References: <bug-11063-27@http.bugzilla.kernel.org/>,
 <20080709152716.99e9bbe7.akpm@linux-foundation.org>,
 <Pine.LNX.4.64.0807102110130.16171@blonde.site> <4876997B.15434.250C736@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008, pageexec@freemail.hu wrote:
> On 10 Jul 2008 at 21:19, Hugh Dickins wrote:
> 
> > Therefore re-evaluate VM_STACK_FLAGS in setup_arg_pages, where stack
> > vm_flags used to be set, before the mprotect_fixup.  Checking through
> > our existing VM_flags, none would have changed since insert_vm_struct:
> > so this seems safer than finding a way through the personality labyrinth.
> 
> alternatively, if there's a concern of stack_vma->vm_flags manipulation
> during execve (maybe not now, but in the future or in non-ELF formats
> that also want to rely on personality bits), you could opt for a safer
> 
> 	vm_flags = vma->vm_flags | (VM_STACK_FLAGS & (VM_EXEC | VM_MAYEXEC));
> 
> to just recompute the exec rights related bits.

True.  It was a concern that crossed my mind (I was thinking particularly
of the VM_ACCOUNT flag, which gets added in once we deal with a writable
private mapping, but is set from the start here anyway), but I don't
think it's worth changing my

> > -	vm_flags = vma->vm_flags;
> > +	vm_flags = VM_STACK_FLAGS;

now that's already there in Linus' tree.  If a VM_flag gets added that
changes the picture, it might even need your line above to be changed.

Hugh
