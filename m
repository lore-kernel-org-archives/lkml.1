Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYJWN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYJWN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYJWN6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:58:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48845 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYJWN6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:58:03 -0400
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a
	process
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <amirkin@parallels.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com,
       Cedric Le Goater <clg@fr.ibm.com>, Andrey Mirkin <major@openvz.org>,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <200810231300.50628.amirkin@parallels.com>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <200810221412.14174.major@openvz.org> <48FF45CF.5000306@cs.columbia.edu>
	 <200810231300.50628.amirkin@parallels.com>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 06:57:57 -0700
Message-Id: <1224770277.12673.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 13:00 +0400, Andrey Mirkin wrote:
> 
> > >>> It is not related to the freezer code actually.
> > >>> That is needed to restart syscalls. Right now I don't have a code in my
> > >>> patchset which restarts a syscall, but later I plan to add it.
> > >>> In OpenVZ checkpointing we restart syscalls if process was caught in
> > >>> syscall during checkpointing.
> > >>
> > >> Do you checkpoint uninterruptible syscalls as well? If only
> > >> interruptible syscalls are checkpointed, I'd say that either this
> > >> syscall uses ERESTARTSYS or ERESTART_RESTARTBLOCK, and then signal
> > >> handling code already does the trick, or this syscall does not restart
> > >> itself when interrupted, and well, this is life, userspace just sees
> > >> -EINTR, which is allowed by the syscall spec.
> > >> Actually this is how we checkpoint/migrate tasks in interruptible
> > >> syscalls in Kerrighed and this works.
> > >
> > > We checkpoint only interruptible syscalls. Some syscalls do not restart
> > > themself, that is why after restarting a process we restart syscall to
> > > complete it.
> >
> > Can you please elaborate on this ?  I don't recall having had issues
> > with that.
> 
> Right now in 2.6.18 kernel we restarts in such a way pause, rt_sigtimedwait 
> and futex syscalls. Recently futex syscall was reworked and we will not need 
> such hooks for it.

Could you elaborate on this a bit?

If the futex syscall was reworked, perhaps we can do the same for
rt_sigtimedwait() and get rid of this code completely.

-- Dave

