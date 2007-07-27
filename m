Return-Path: <linux-kernel-owner+w=401wt.eu-S937461AbXG0PbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937461AbXG0PbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760492AbXG0PbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:31:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48215 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbXG0PbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:31:12 -0400
X-Sasl-enc: CdYs9I26inPPxmhqFfj0yS8j92KmbiVoisbXxOKqKuPX 1185550270
Subject: Re: request for patches: showing mount options
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kzak@redhat.com, ericvh@gmail.com,
       lucho@ionkov.net, zippel@linux-m68k.org, hpa@zytor.com,
       rathamahata@php4.ru, dhowells@redhat.com, sfrench@samba.org,
       mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
In-Reply-To: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 23:30:56 +0800
Message-Id: <1185550256.3203.77.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 15:45 +0200, Miklos Szeredi wrote:
> [please consider pruning the CC list if discussing some aspect, which
> doesn't concern all]
> 
> I've done an audit of all filesystems with regards to showing mount
> options in /proc/<pid>/mounts.  Unfortunately most of them show none
> or only a part of all accepted options (for details see list of
> filesystems at the end of the mail).
> 
> This is currently not a big problem, because mount(8) stores the given
> options in /etc/mtab.  However we want to get rid of mtab, and this
> requires, that the option showing be fixed up.
> 
> It would be easiest if this was done by the VFS instead of having to
> deal with it in filesystems.  However there are differences in how
> filesytems handle options during mount and remount, and it would be
> impossible to take this into account in all cases.
> 
> If you are CC-ed, and responsible for one of these filesystems, please
> take a moment to fully implement the ->show_options() method.  In most
> cases it should be an easy task.
> 
> If for some reason you are unable to do this, please let me know and
> I'll fix it up.
> 
> Here are some guidelines for showing options.  I'll also add these to
> Documentation/filesystems/vfs.txt
> 
> +   If a filesystem accepts mount options, it must define show_options()
> +   to show all the currently active options.  The rules are:
> +
> +     - options MUST be shown which are not default or their values differ
> +       from the default
> +
> +     - options MAY be shown which are enabled by default or have their
> +       default value
> +
> +   Options used only internally between a mount helper and the kernel
> +   (such as file descriptors), or which only have an effect during the
> +   mounting (such as ones controlling the creation of a journal) are exempt
> +   from the above rules.
> 
> Thanks,
> Miklos
> 
> -------
> legend:
> 
>   all - fs has options, but doesn't define ->show_options()
>   some - fs defines ->show_options(), but some options are not shown
>   noopt - fs does not have options
>   good - fs shows all options
>   patch - I have a patch
> 
> 
> 9p          some
> adfs        all (maintainer?)
> affs        all
> afs         all
> autofs      all

I'm not sure I understand this.
How does autofs show it's options without a ->show_options method?

> autofs4     some

OK, uid and gid aren't shown.
That should be straight forward to fix.
What's your time frame for this?

Ian


