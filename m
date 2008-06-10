Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYFJRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYFJRVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYFJRVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:21:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44092 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYFJRVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:21:09 -0400
Date: Tue, 10 Jun 2008 19:21:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Dike <jdike@addtoit.com>,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: 2.6.26-rc5-mm1: uml link error
Message-ID: <20080610172150.GA4728@uranus.ravnborg.org>
References: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com> <484E8DD2.5050603@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E8DD2.5050603@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 04:21:06PM +0200, Peter Oberparleiter wrote:
> Peter 1 Oberparleiter wrote:
> > Jeff Dike <jdike@addtoit.com> wrote on 10.06.2008 15:57:29:
> > 
> >> On Tue, Jun 10, 2008 at 01:19:27PM +0200, Miklos Szeredi wrote:
> >> > Hmm, uml still doesn't boot with this patch, it dies while calling the
> >> > constructors.  So maybe that SORT contruct is still needed?
> >> > 
> >> > #17 0x08049793 in do_ctors () at init/main.c:706
> >> > #18 0x080499cc in do_basic_setup () at init/main.c:789
> >> > #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897
> >> 
> >> This doesn't look like it's in do_initcalls.  What happens with
> >> "initcall_debug"?
> > 
> > Constructor calls inside the kernel happen just before any other
> > initcall. The problem here is that constructors are called from both
> > the host run-time environment as well as from the kernel. I'm
> > working on a patch that disables kernel constructor calling for UML.
> 
> New try: should be fixed with the patch below (applies on top of
> kernel-call-constructors.patch):
> 
> --
> Subject: kernel: disable constructor calling for uml
> 
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Disable calling of constructor functions from within the kernel for uml
> as they are already called by the host run-time environment.

If this is the right fix then could we please have a less ugly patch.
First off there is no need for the ifdef in vmlinux.lds.h.
And we could get away with some flag or something where we 
call the constructors.

And a comment explaning why UML is different is also missing.

	Sam
