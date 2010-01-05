Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551Ab0AEIs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0AEIs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907Ab0AEIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:48:57 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41736 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0AEIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:48:56 -0500
Date: Tue, 5 Jan 2010 17:48:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Venkappa Mala <Venkappa.Mala@lntinfotech.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "rmk+lkml@arm.linux.org.uk" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: Linux kernel crash dumps for ARM
Message-ID: <20100105084850.GA27860@linux-sh.org>
References: <EB1A7C66AD0C92419BFFC785A947865A09EA8C9129@BLRINMSMBX01.bglrodc.lntinfotech.com> <m17hrx9lgo.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hrx9lgo.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 09:20:23PM -0800, Eric W. Biederman wrote:
> Venkappa Mala <Venkappa.Mala@lntinfotech.com> writes:
> >
> > 2) As per kexec supports, kexec-tool is required and this allows you to load directly
> >    to a new kernel from the currently running one
> >
> >     As from my side, i am not able to find arm implementation support in kexec-tools/crash sources.
> >
> >    - is kexce-tool supported for ARM or not?
> >
It would be rather counterintuitive for the kernel to support kexec and
the necessary userspace components not to.

The MAINTAINERS file says:

KEXEC
M:      Eric Biederman <ebiederm@xmission.com>
W:      http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
L:      kexec@lists.infradead.org
S:      Maintained
F:      include/linux/kexec.h
F:      kernel/kexec.c

While the above URL redirects to gitweb, resulting in:

http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools.git;a=summary

A peripheral grep of the kexec-tools source results in:

$ git grep kdump | grep arm
kexec/arch/arm/kexec-arm.c:     return 0; /* kdump is not supported on this platform (yet) */

So one could infer that kexec is supported on ARM whilst kdump is not. Adding
crashdump support requires both some kernel and kexec-tools glue, but is fairly
straightforward, just look at the other ports.
