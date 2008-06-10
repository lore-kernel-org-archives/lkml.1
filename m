Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYFJOJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYFJOJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYFJOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:09:26 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:41336 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbYFJOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:09:25 -0400
In-Reply-To: <20080610135729.GA6087@c2.user-mode-linux.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>, oberparleiter@googlemail.com
MIME-Version: 1.0
Subject: Re: 2.6.26-rc5-mm1: uml link error
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Tue, 10 Jun 2008 16:08:51 +0200
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 10/06/2008 16:09:07,
	Serialize complete at 10/06/2008 16:09:07
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike <jdike@addtoit.com> wrote on 10.06.2008 15:57:29:

> On Tue, Jun 10, 2008 at 01:19:27PM +0200, Miklos Szeredi wrote:
> > Hmm, uml still doesn't boot with this patch, it dies while calling the
> > constructors.  So maybe that SORT contruct is still needed?
> > 
> > #17 0x08049793 in do_ctors () at init/main.c:706
> > #18 0x080499cc in do_basic_setup () at init/main.c:789
> > #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897
> 
> This doesn't look like it's in do_initcalls.  What happens with
> "initcall_debug"?

Constructor calls inside the kernel happen just before any other
initcall. The problem here is that constructors are called from both
the host run-time environment as well as from the kernel. I'm
working on a patch that disables kernel constructor calling for UML.


Regards,
  Peter
