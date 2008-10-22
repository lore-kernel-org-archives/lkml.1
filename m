Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYJVMo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYJVMo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYJVMoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:44:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:33741 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYJVMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:44:20 -0400
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a
	process
From: Greg Kurz <gkurz@fr.ibm.com>
To: Louis.Rilling@kerlabs.com
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20081022104448.GX15171@hawkmoon.kerlabs.com>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-9-git-send-email-major@openvz.org>
	 <48FC4E0C.7050008@fr.ibm.com> <200810221249.55600.major@openvz.org>
	 <20081022092502.GW15171@hawkmoon.kerlabs.com>
	 <1224669979.4210.15.camel@localhost.localdomain>
	 <20081022104448.GX15171@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 14:44:15 +0200
Message-Id: <1224679455.4210.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 12:44 +0200, Louis Rilling wrote:
> On Wed, Oct 22, 2008 at 12:06:19PM +0200, Greg Kurz wrote:
> > On Wed, 2008-10-22 at 11:25 +0200, Louis Rilling wrote:
> > > Do you checkpoint uninterruptible syscalls as well? If only interruptible
> > > syscalls are checkpointed, I'd say that either this syscall uses ERESTARTSYS or
> > > ERESTART_RESTARTBLOCK, and then signal handling code already does the trick, or
> > > this syscall does not restart itself when interrupted, and well, this is life,
> > > userspace just sees -EINTR, which is allowed by the syscall spec.
> > > Actually this is how we checkpoint/migrate tasks in interruptible syscalls in
> > > Kerrighed and this works.
> > > 
> > > Louis
> > > 
> > 
> > I don't know Kerrighed internals but I understand you perform checkpoint
> > with a signal handler. Right ?
> 
> Right. This is an kernel-internal-only signal, so all signals remain available
> for userspace.
> 
> > This approach has a huge benefit: the
> > signal handling code do all the arch dependant stuff to save registers
> > in user memory.
> 
> Hm, I'm not sure to understand what you mean here. We just rely on arch code
> that jumps to signal handling to correctly setup struct pt_regs, which is then
> passed to the checkpoint code. So yes, userspace registers are mostly saved by
> existing arch code. But in x86-64 for instance, segment registers still need to
> be saved by the checkpoint code (a bit like copy_thread() does), and I don't
> know arch-independent functions doing this.
> 

You're right, some segment registers need to be saved on x86 also... I
should have written 'most of' in my previous mail.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

