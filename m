Return-Path: <linux-kernel-owner+w=401wt.eu-S1945958AbXDEGrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbXDEGrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945962AbXDEGrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:47:04 -0400
Received: from gw.goop.org ([64.81.55.164]:44189 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945958AbXDEGrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:47:03 -0400
Message-ID: <46149B45.2070502@goop.org>
Date: Wed, 04 Apr 2007 23:46:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Jan Beulich <JBeulich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped location
 with COMPAT_VDSO
References: <20070405063152.9227D180064@magilla.sf.frob.com>
In-Reply-To: <20070405063152.9227D180064@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> The patch looks nice and clean.  However, it does not relocate the symbol
> table(s) values.  I thought that was done in an earlier version of this I
> saw, but I might be misremembering.  Though not fatal, this is a regression
> from the previous CONFIG_COMPAT_VDSO behavior.  It will show up in things
> like __kernel_* name display in backtraces.

Hm, OK.  It does, but I wasn't sure if it would matter.  It should be
fairly simple to fix up.

>   If with your other patch
> CONFIG_COMPAT_VDSO will become other than a rarely-used compatibility
> option, then this should be fixed.  Note that with your second patch this
> will also break the symbol values in the randomly-located vma vdso;
> non-ancient glibc doesn't care if the vdso isn't mapped where its phdrs
> say, but everything does still care that the symbol tables in an ELF file
> use addresses matching the phdrs in the same file.
>   

I did the second patch because I could, and to see if it would provoke
some comment.  But effectively removing a kernel config option seems
like a good idea to me.

    J
