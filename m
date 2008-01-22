Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYAVW2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYAVW2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYAVW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:28:44 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45052 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYAVW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:28:43 -0500
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49
	__fput+0x1a8/0x1e0()
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, sparclinux@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20080122130228.e7596163.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <200801222130.24136.m.kozlowski@tuxland.pl>
	 <20080122130228.e7596163.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 14:28:40 -0800
Message-Id: <1201040920.7585.43.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-22 at 13:02 -0800, Andrew Morton wrote:
> > WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> > Modules linked in: sg sr_mod cdrom
> > Call Trace:
> >  [00000000004c9ac8] __fput+0x1b0/0x1e0
> >  [00000000004c6978] filp_close+0x60/0x80
> >  [00000000004c6a18] sys_close+0x80/0xe0
> >  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
> >  [0000000000012f1c] 0x12f24
> > ---[ end trace 6dbe14ff8ec57744 ]---
> > 
> 
> That's
> 
>         WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
> 
> cc's added...

I've reproduced it, and I'm looking in to it.  I should have a patch
shortly.

-- Dave

