Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXF0RRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXF0RRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXF0RRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:17:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36746 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbXF0RRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:17:08 -0400
Date: Wed, 27 Jun 2007 19:18:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
Message-ID: <20070627171812.GA31705@uranus.ravnborg.org>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 03:58:43PM +0200, Joerg Schilling wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jun 25, 2007 at 04:53:55PM +0200, Joerg Schilling wrote:
> > > 
> > > star needs "ext2_fs.h". This file is not usable at all on many Linux 
> > > distributions, even with GCC.
> >
> > I was curious so I did:
> >
> > $ mkdir ~/foo
> > $ cd ~/kernel/linux-2.6
> > $ make INSTALL_HDR_PATH=~/foo
> > $ cd ~/foo
> > $ cat j.c
> > #include <stdio.h>
> > #include "etx2_fs.h"
> >
> > main()
> > {
> > 	printf("helloo\n");
> > }
> >
> > $ gcc -o j j.c
> > => No warning, no errors
> >
> 
> On Suse Linux 10.0, I get e.g.:
> 
> cat t.c
> #include <stdio.h>
> #include <linux/ext2_fs.h>
> 
> gcc -c t.c
> In file included from /usr/include/linux/ext2_fs.h:20,
>                  from t.c:2:
> /usr/include/linux/ext2_fs_sb.h:40: error: syntax error before âuid_tâ
> /usr/include/linux/ext2_fs_sb.h:49: error: syntax error before âs_next_generationâ
> /usr/include/linux/ext2_fs_sb.h:51: error: syntax error before â*â token
> /usr/include/linux/ext2_fs_sb.h:56: error: syntax error before â}â token

Hi Jörg.

For my test I used latest -git of the Linux kernel.
In this version the include of ext2_fs_bh.h is guarded
by __KERNEL__ like this:

#ifdef __KERNEL__
#include <linux/ext2_fs_sb.h>
static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
{
        return sb->s_fs_info;
}

And therefore the include statement is removed in the exported set of kernel
include files.
So this particular issue is solved with the latest kernel and using the headers
prepared for export.

This tells me that we are on the right track with exporting the headers and sanitize them.

	Sam
