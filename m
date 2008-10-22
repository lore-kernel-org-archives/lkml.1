Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYJVKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYJVKHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYJVKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:07:13 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:39766 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYJVKHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:07:12 -0400
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a
	process
From: Greg Kurz <gkurz@fr.ibm.com>
To: Louis.Rilling@kerlabs.com
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20081022092502.GW15171@hawkmoon.kerlabs.com>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-9-git-send-email-major@openvz.org>
	 <48FC4E0C.7050008@fr.ibm.com> <200810221249.55600.major@openvz.org>
	 <20081022092502.GW15171@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 12:06:19 +0200
Message-Id: <1224669979.4210.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 11:25 +0200, Louis Rilling wrote:
> Do you checkpoint uninterruptible syscalls as well? If only interruptible
> syscalls are checkpointed, I'd say that either this syscall uses ERESTARTSYS or
> ERESTART_RESTARTBLOCK, and then signal handling code already does the trick, or
> this syscall does not restart itself when interrupted, and well, this is life,
> userspace just sees -EINTR, which is allowed by the syscall spec.
> Actually this is how we checkpoint/migrate tasks in interruptible syscalls in
> Kerrighed and this works.
> 
> Louis
> 

I don't know Kerrighed internals but I understand you perform checkpoint
with a signal handler. Right ? This approach has a huge benefit: the
signal handling code do all the arch dependant stuff to save registers
in user memory.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

