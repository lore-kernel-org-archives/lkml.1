Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYFBK1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYFBK1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYFBK1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:27:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:35582 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbYFBK1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:27:39 -0400
Date: Mon, 2 Jun 2008 12:27:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <20080601005338.3affe880.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806021223120.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
 <20080601005338.3affe880.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Andrew Morton wrote:

> > -	if (brk < mm->start_brk)
> > +#ifdef CONFIG_COMPAT_BRK
> > +	min_brk = mm->end_code;
> > +#else
> > +	min_brk = mm->start_brk;
> > +#endif
> > +	if (brk < min_brk)
> >  		goto out;
> >  
> OK, we have a problem here.
> Somebody has gone and checked this patch into their tree and it now
> appears in linux-next.

Ah, I have expected either you or Ingo (as my patch that introduced the 
bug went through his tree too) to pick that up.

> I do not know how to work out how this patch got into linux-next.

Well, git-blame on mm/mmap.c in linux-next tree shows the commit id, and 
then git-show --pretty=full tells you the comitter name.

-- 
Jiri Kosina
SUSE Labs
