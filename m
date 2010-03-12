Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0CLWtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:49:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205Ab0CLWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:49:05 -0500
Date: Fri, 12 Mar 2010 14:48:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
Message-Id: <20100312144854.cb94d9b4.akpm@linux-foundation.org>
In-Reply-To: <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com>
References: <4B968834.3040609@gmail.com>
	<21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
	<2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
	<21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
	<2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 13:15:25 +0100
Marco Stornelli <marco.stornelli@gmail.com> wrote:

> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
> > 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
> >> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
> >>> Hi,
> >>>
> >>> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
> >>>> Ramoops, like mtdoops, can log oops/panic information but in RAM.
> >>>
> >>> What is different from mtdoops + mtd-ram?
> >>>
> >>> Yoichi
> >>>
> >>
> >> It can be used in a very easy way with persistent RAM for systems
> >> without flash support. For this systems, with this driver, it's no
> >> more needed add to the kernel the mtd subsystem with advantage in
> >> footprint as I said in the description.
> >
> > right.
> > But,
> >
> >> In addition, you can save
> >> flash space and store this information only in RAM. I think it's very
> >> useful for embedded systems.
> >
> > CONFIG_MTD_RAM uses only RAM.
> > I think there's no big difference about this point.
> >
> 
> I meant with the "classic" use of mtdoops, therefore with a flash
> partition without use MTD_RAM. Using MTD_RAM, it's more or less the
> same thing, with the exception of "where" you want deploy the log. For
> example: if in your system you have got a nvram you can use it without
> problem, you need to specify the address of the nvram to the module.
> Very simple. I  think it's a small driver but very useful, feedback
> from other embedded guys are welcome.

Seems sensible to me.  If you have a machine whose memory is persistent
across reboots then you reserve an arbitrary 4k hunk of memory for
collecting oops traces, yes?

What tools are used for displaying that memory on the next boot?  How
do those tools distinguish between "valid oops trace" and "garbage
because it was just powered on"?  A magic signature?

Should the kernel provide the 4k of memory rather than (or in addition
to) requiring that the system administrator reserve it and tell the
kernel about it?  That'd be a matter of creating a linker section which
isn't cleared out by the startup code.

