Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXCZWXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXCZWXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCZWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:23:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbXCZWXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:23:03 -0400
Date: Mon, 26 Mar 2007 15:22:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070326152249.1d31458f.akpm@linux-foundation.org>
In-Reply-To: <1174946277.16728.14.camel@dyn9047017100.beaverton.ibm.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174946277.16728.14.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 13:57:57 -0800
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> > 
> 
> 
> Panics my x86-64 box. 2.6.21-rc4 works fine.
> Ideas on where to start ? Bisect ?
> 
> Thanks,
> Badari
> 
> ..
> ReiserFS: hda2: found reiserfs format "3.6" with standard journal
> ReiserFS: hda2: using ordered data mode
> ReiserFS: hda2: journal params: device hda2, size 8192, journal first
> block 18, max trans len 1024, max batch 900, max commit age 30, max
> trans age 30
> ReiserFS: hda2: checking transaction log (hda2)
> ReiserFS: hda2: Using r5 hash to sort names
> VFS: Mounted root (reiserfs filesystem) readonly.
> Freeing unused kernel memory: 376k freed
> INIT: version 2.86 booting
> Unable to handle kernel NULL pointer dereference at 0000000000000020
> RIP:
>  [<ffffffff804ec090>] __sched_text_start+0x460/0x889
> PGD 1c1898067 PUD 1c1897067 PMD 0
> Oops: 0000 [1] SMP
> last sysfs file: block/hda/range
> CPU 3
> Modules linked in:
> Pid: 900, comm: boot Not tainted 2.6.21-rc4-mm1 #1
> RIP: 0010:[<ffffffff804ec090>]  [<ffffffff804ec090>] __sched_text_start

This is a very popular oops, caused by the rsdl scheduler.  I don't _think_
we yet know exactly why it is happening.  Con, did you get to the bottom
of this?

We don't know why it confused kallsyms either.

I'll try to shove rc5-mm1 out the door this evening, minus rsdl.  And
-mm2, with rsdl.
