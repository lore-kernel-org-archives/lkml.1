Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYAYA1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYAYA1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYAYA1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:27:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53458 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbYAYA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:27:09 -0500
Date: Thu, 24 Jan 2008 19:24:48 -0500
Message-Id: <200801250024.m0P0OmXX011168@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve French <sfrench@us.ibm.com>,
       Lachlan McIlroy <lachlan@sgi.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Russell King <rmk@arm.linux.org.uk>,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Karsten Keil <kkeil@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jeff Dike <jdike@addtoit.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       William Irwin <wli@holomorphy.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Jeff Mahoney <jeffm@suse.com>, Paul Mackerras <paulus@samba.org>,
       Hugh Dickins <hugh@veritas.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 01/26] mount options: add documentation 
In-reply-to: Your message of "Thu, 24 Jan 2008 20:33:42 +0100."
             <20080124193416.379218079@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080124193416.379218079@szeredi.hu>, Miklos Szeredi writes:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This series addresses the problem of showing mount options in
> /proc/mounts.
> 
> Several filesystems which use mount options, have not implemented a
> .show_options superblock operation.  Several others have implemented
> this callback, but have not kept it fully up to date with the parsed
> options.
[...]

> The following filesystems still need fixing: CIFS, NFS, XFS, Unionfs,
> Reiser4.  For CIFS, NFS and XFS I wasn't able to understand how some
> of the options are used.  The last two are not yet in mainline, so I
> leave fixing those to their respective maintainers out of pure
> laziness.
> 
> Table displaying status of all in-kernel filesystems:
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> legend:
> 
>   none - fs has options, but doesn't define ->show_options()
>   some - fs defines ->show_options(), but some only options are shown
>   most - fs defines ->show_options(), and shows most of them
>   good - fs shows all options
>   noopt - fs does not have options
>   patch - a patch will be posted
[...]

> in -mm:
> 
> reiser4     some
> unionfs     none

Hi Miklos,

Where did you check for the existence of a ->show_options method for
unionfs?  Unionfs does implement ->show_options and supports all of the
mount/remount options.  See:

<http://git.kernel.org/?p=linux/kernel/git/ezk/unionfs.git;a=blob;f=fs/unionfs/super.c;h=986c980261a5b171147d66ac05bf08423e2fd6b6;hb=HEAD#l963>

The unionfs ->remount code supports branch-management options which can
add/del/change a branch, but we don't show those directly in ->show_options;
it makes more sense to show the final (and thus most current) branch
configuration.

Could you update your records please?

BTW, I should be able to use your save_mount_options().

Cheers,
Erez.
