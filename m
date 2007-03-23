Return-Path: <linux-kernel-owner+w=401wt.eu-S1750914AbXCWQSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbXCWQSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXCWQSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:18:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50330 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXCWQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:18:35 -0400
Date: Fri, 23 Mar 2007 17:19:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Miles Lane <miles.lane@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- WARNING: could not find versions for .tmp_versions/built-in.mod
Message-ID: <20070323161903.GA7485@uranus.ravnborg.org>
References: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com> <20070320212705.GB13349@uranus.ravnborg.org> <20070323214418.3F04.Y-GOTO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323214418.3F04.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 09:54:29PM +0900, Yasunori Goto wrote:
> Hello.
> 
> > > WARNING: mm/built-in.o - Section mismatch: reference to
> > > .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> > > offset 0x15c8f) and '__section_nr'
> > I took a look at this one.
> > You have SPARSEMEM enabled in your config.
> > And then I see that in sparse.c we call alloc_bootmem_node()
> > from a function I thought should be marked __devinit (it
> > is used by memory_hotplug.c).
> > But I am not familiar enough to judge if __alloc_bootmen_node
> > are marked correct with __init or __devinit (to say
> > this is used in the HOTPLUG case) is more correct.
> > Anyone?
> > 
> > > WARNING: mm/built-in.o - Section mismatch: reference to
> > > .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> > > offset 0x15d02) and '__section_nr'
> > Same as above....
> 
> Memory hotplug code has __meminit for its purpose.
> But, I suspect that many other places of memory hotplug code may have
> same issue. I will chase them.
Thanks!

> 
> BTW, does -mm code checks more strict than stock kernel? I can't see
> these warnings in 2.6.21-rc4.....
Yes it does. The included kbuild changes enables proper check of
symbols in vmlinux.

	Sam
