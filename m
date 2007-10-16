Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXJPPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXJPPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbXJPPSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:18:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:7049 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbXJPPSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rA8KZQf9YxImL0FK690V08yREUnbPiRza03xtzYqstztpL02ZGt2xwjChNbwlbFL3c39z7FZ2Rl3GlrXF31k9mBLNyZd7zK0ZjRC33K9pgaV3OMQ6GE5OnAjRLkPLxP4OHqRYKWXQqjrECAKB/3oLCi/XFdJsVmtCws1XeWye+U=
Message-ID: <4dfa50520710160817l2774c983u2531a45ff08d8c80@mail.gmail.com>
Date: Tue, 16 Oct 2007 08:17:58 -0700
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.23-git8: Lock dependency engine debugging failure
In-Reply-To: <1192543173.27435.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dfa50520710152028i4a976200s88fbbb7f1cc2da9@mail.gmail.com>
	 <1192543173.27435.96.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/16/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2007-10-15 at 20:28 -0700, David Hubbard wrote:
> > I am not subscribed to LKML, so please CC me in replies. I am
> > reporting a regression when CONFIG_DEBUG_LOCKDEP is enabled in
> > 2.6.23-git8. The error occurs immediately before loading init.
> > Complete dmesg and kernel config are attached.
> >
> > [   28.528074] VFS: Mounted root (ext3 filesystem) readonly.
> > [   28.528090] Freeing unused kernel memory: 212k freed
> > [   28.537431] Write protecting the kernel read-only data: 1036k
> > [   28.622874] WARNING: at kernel/lockdep.c:2658 check_flags()
>
> Could you try if the below patch works for you?
>
> --
> Subject: lockdep: fix fault vs irq tracing
>
> Ensure we fixup the IRQ state before we hit any locking code.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/fault_32.c |   10 ++++++++++
>  arch/x86/mm/fault_64.c |   10 ++++++++++
>  2 files changed, 20 insertions(+)

That fixed the problem.

Cheers!
David
