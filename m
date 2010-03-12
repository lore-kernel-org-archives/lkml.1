Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732Ab0CLXbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:31:48 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49714 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713Ab0CLXbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:31:47 -0500
Date: Fri, 12 Mar 2010 23:31:44 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
Message-ID: <20100312233144.GG6491@shareable.org>
References: <4B968834.3040609@gmail.com> <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com> <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com> <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com> <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com> <20100312144854.cb94d9b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312144854.cb94d9b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > I meant with the "classic" use of mtdoops, therefore with a flash
> > partition without use MTD_RAM. Using MTD_RAM, it's more or less the
> > same thing, with the exception of "where" you want deploy the log. For
> > example: if in your system you have got a nvram you can use it without
> > problem, you need to specify the address of the nvram to the module.
> > Very simple. I  think it's a small driver but very useful, feedback
> > from other embedded guys are welcome.
> 
> Seems sensible to me.  If you have a machine whose memory is persistent
> across reboots then you reserve an arbitrary 4k hunk of memory for
> collecting oops traces, yes?

Me too, I think it's a great idea which sounds simpler to use than MTD-RAM.

> What tools are used for displaying that memory on the next boot?  How
> do those tools distinguish between "valid oops trace" and "garbage
> because it was just powered on"?  A magic signature?
> 
> Should the kernel provide the 4k of memory rather than (or in addition
> to) requiring that the system administrator reserve it and tell the
> kernel about it?  That'd be a matter of creating a linker section which
> isn't cleared out by the startup code.

It's good if there's an option to make the location not vary between
kernels, and be known to the bootloader.

Then you can debug kernels which always crash during boot, by either
booting into another kernel which works and looking at the oops, or by
a bootloader command to dump it.

That'd be fine if the kernel link scripts choose the address, as long
as it's consistent between different compiles and similar
configurations.  That'd be a bit simpler than the admin having to know
the memory map well enough to choose an address.

-- Jamie
