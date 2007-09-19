Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXISVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXISVnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXISVnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:43:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbXISVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:43:00 -0400
Date: Wed, 19 Sep 2007 14:42:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-Id: <20070919144246.8a85489d.akpm@linux-foundation.org>
In-Reply-To: <46F18037.1020505@gmail.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F10B69.5070008@gmail.com>
	<46F10DCB.1090302@gmail.com>
	<46F13938.1070709@gmail.com>
	<20070919121017.0cbcbc30.akpm@linux-foundation.org>
	<20070919192453.GB18707@one.firstfloor.org>
	<46F17CA1.5080205@gmail.com>
	<20070919195425.GF18707@one.firstfloor.org>
	<46F17F27.5080000@gmail.com>
	<46F18037.1020505@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 22:01:59 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 09/19/2007 09:57 PM, Jiri Slaby wrote:
> > On 09/19/2007 09:54 PM, Andi Kleen wrote:
> >>> Yeah. (But X doesn't run -- this is maybe the known issue in this release).
> >> What do you mean with not run? 
> > 
> > (II) intel(0): Initializing HW Cursor
> > (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
> > (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
> >         at offset 0x5ff000 failed (Invalid argument)
> > 
> > Fatal server error:
> > Couldn't bind memory for front buffer
> 
> Further info:
> 4690  write(0, "(II) intel(0): Initializing HW C"..., 38) = 38
> 4690  write(0, "(II) intel(0): xf86BindGARTMemor"..., 76) = 76
> 4690  ioctl(9, AGPIOC_BIND, 0x7fffbe1cb850) = -1 EINVAL (Invalid argument)
> 4690  write(0, "(WW) intel(0): xf86BindGARTMemor"..., 115) = 115
> 4690  write(2, "\nFatal server error:\n", 21) = 21
> 

This might be a Dave thing and not an Andi thing.

In my usual -mm-testing I only test X on the one machine (the Vaio,
natch).  Check that it runs glxgears, check suspend/resume to mem and disk.
It has intel graphics and I'm not seeing any such problems.

Have you time to bisect it? 
http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt
describes how.

As a quick test, perhaps build a tree with just
2.6.23-rc6+origin.patch+git-drm.patch?  Fortunately git-agpgart.patch is
presently empty.

