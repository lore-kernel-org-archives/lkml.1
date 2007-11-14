Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbXKNKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbXKNKgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXKNKgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:36:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48838 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751697AbXKNKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:36:12 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-reply-to: <20071114011002.GA11477@c2.user-mode-linux.org> (message from
	Jeff Dike on Tue, 13 Nov 2007 20:10:02 -0500)
Subject: Re: uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org>
Message-Id: <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Nov 2007 11:35:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 14, 2007 at 12:32:43AM +0100, Miklos Szeredi wrote:
> > UML doesn't run on 2.6.24-rc2 as host (config attached).  Guest is
> > 2.6.23-mm1, but I guess it's irrelevant.  2.6.23 as host was OK.
> > 
> > When booting there are zillions of lines like this:
> > 
> > "arch_switch_tls failed, errno = EINVAL"
> 
> This is PTRACE_ARCH_PRCTL failing and the only EINVAL I see is
> do_arch_prctl getting a bogus operation - something other than
> ARCH_[GS]ET_[FG]S, which is strange because UML never would have
> worked if it were passing in bogus arguments.

Note, this is 32bit UML on 64bit host, to complicate matters.  So I
think it's not PTRACE_ARCH_PRCTL, but PTRACE_SET_THREAD_AREA.

Maybe this is a fallout from the x86 architecture merge?

Tglx and mingo cc-d.

Miklos
