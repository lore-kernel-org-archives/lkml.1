Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYGVMj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYGVMj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYGVMjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:39:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33283 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYGVMjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:39:47 -0400
Date: Tue, 22 Jul 2008 16:43:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Message-ID: <20080722124314.GA3267@tv-sign.ru>
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org> <20080721102940.666d733d@the-village.bc.nu> <20080721210121.C5E741541A5@magilla.localdomain> <20080721221416.6d4f9014@lxorguk.ukuu.org.uk> <20080722113731.GA1383@tv-sign.ru> <20080722121824.GB1383@tv-sign.ru> <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Michael Kerrisk wrote:
>
> On Tue, Jul 22, 2008 at 2:18 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > If the coredumping is multi-threaded, format_corename() appends .%pid
> > to the corename. This was needed before the proper multi-thread core
> > dump support, now all the threads in the mm go into a single unified
> > core file.
> >
> > Remove this special case, it is not even documented and we have "%p"
> > and core_uses_pid.
> 
> Hi Oleg,
> 
> I have not thought about this at any length, but one question that
> jumps to mind: could this feature still be useful for LinuxThreads,
> where each thread does indeed have a separate PID?

As far as I know, LinuxThreads use CLONE_VM, right?

The coredump will create the single core file for all processes because
they have the same ->mm, the "threads" won't dump all over each other.

And, just in case, this patch doesn't make any difference if core_uses_pid
is set or pid_in_pattern is true.

That said, this is the user-visible change...

Oleg.

