Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYDUQiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYDUQiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYDUQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:38:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:58612 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYDUQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bscPVz/GIG+8FhDU+XZkPdLw8Sr4mYkbTLTs7XFBL1z87GRFX0Up7whdll+tvgnjR/lwfmuOefS3ADqZSTkThu0HpGTnq1DdEGrhQso6w/yJGLYjw1PENMsuc7Vdi0pLTLAD8OlrnhF32CMHnxf7hng01m+zqs/tzhMpvLR8sn8=
Message-ID: <86802c440804210938w8e401fg11d4aaa5646cce8a@mail.gmail.com>
Date: Mon, 21 Apr 2008 09:38:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: memtest bootparam
Cc: "Pavel Machek" <pavel@ucw.cz>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel.send@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080421141735.GS9554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181717.m3IHHicT031344@hera.kernel.org>
	 <20080418145202.c96460a2.akpm@linux-foundation.org>
	 <20080419133333.GC23873@elf.ucw.cz>
	 <86802c440804191354q45fdedelce0ec38ba52f3880@mail.gmail.com>
	 <20080421141735.GS9554@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 7:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> > >  > OK.  Did the new memtest feature get documented anywhere, btw?
> > >  > I'm only vaguely aware of its existence.
> > >
> > >  Actually it would be nice if memtest was global, not x86-specific,
> > >  feature.
> > >
> > >  I had some fun with arm running with 256mb, when only 128mb was
> > >  present. It booted succesfully...
> >
> > depends if you have find_e820_area_size in you platform. that need
> > reserve_early...
> >
> > maybe we need to make reserve_early generic at first.
>
> e820 is very x86 specific - i think the proper interface would be to
> move the memtest feature to the bootmem subsystem. I.e. to run it once
> all the early reservations have been flushed into bootmem - but before
> we free all bootmem pages into the page allocator.
>
> this still leaves a rather large amount of RAM to be tested, and keeps
> it all cross-arch as well. Hm?

sounds good, and arch part only need to check region that bootdata use
for bootmem allocation.

YH
