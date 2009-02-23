Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZBWXYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZBWXYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZBWXYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:24:32 -0500
Received: from smtp3.ono.com ([62.42.230.176]:32891 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636AbZBWXYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:24:31 -0500
Date: Tue, 24 Feb 2009 00:24:26 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of ext4 tools
Message-ID: <20090224002426.23fd5466@werewolf.home>
In-Reply-To: <20090220124618.GH14810@mini-me.lan>
References: <20090219234838.4c06c98b@werewolf.home>
	<20090220124618.GH14810@mini-me.lan>
X-Mailer: Claws Mail 3.7.0cvs69 (GTK+ 2.15.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late answer...

On Fri, 20 Feb 2009 07:46:18 -0500, Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Feb 19, 2009 at 11:48:38PM +0100, J.A. Magallón wrote:
> > 
> > - Where is the 'official' source for e4defrag ?
> > - I've read that e4defrag needs in-kernel support.
> >   Is it already in mainline ?
> >   From what kernel version ?
> 
> Ext4's defragmentation code is still under development.  There are
> multiple versions of e4defrag, paired with kernel patches that have
> been submitted to linux-ext4@vger.kernel.org.  The patches are not yet
> in in mainline, and the kernel/userspace interface is still subject to
> change (which is why it's not in mainline yet).
> 
> > - I have seen that some distros refer to a package called 'e4fsprogs'.
> >   Does that thing exist ? Where ?
> 
> e4fsprogs was a snapshot of something between e2fprogs 1.41.1 and
> e2fsprogs 1.41.2, if I remember correctly, and it was created for
> RHEL5's technology preview of ext4; the concern was that Red Hat
> didn't want to risk making a major change to e2fsprogs in an
> enterprise distribution; so e4fsprogs is the e2fsprogs's various
> binaries with ext4 support, statically linked.
> 

So, in short, forget online defrag for the moment. No problem.

> > - Booting:
> >   - There seem to be patches for grub
> >     http://lists.openwall.net/linux-ext4/2008/11/19/8
> >     to boot ext4
> >   - and a Google SoC called 'grub4ext4'.
> >    -and there is also grub2 (ext4 support in svn).
> >   What would you recommend ?
> 
> I can't speak to that; I'm still using an ext3 boot partition since
> until very recently I was still using an somewhat oldish (Ubuntu
> Hardy) userspace.  It's exciting enough to be on the bleeding edge of
> the kernel, I don't need to be on the bleeding edge of userspace too.  :-)
> 
> (For example, after my laptop got stolen and I decided to finally move
> to Ubuntu Intrepid, with pulseaudio sound is only sporadically
> working.  And I don't have time to debug how and why the new
> complexities in the !@#!@ sound system is failing.  I'll probably have
> to carve out a few hours to figure out how to rip out pulseaudio by
> its roots, since it clearly isn't working for me.  Lovely...)

So for the full move to ext4 I need a patched grub. I'm not sure I
trust grub2 for the moment...

> 
> > Apart from that, it works pretty fine.
> > The thing that most surprised me was that after the needed fsck, it had
> > converted files with contiguous blocks to big extents ;). Nice.
> 
> Um, e2fsck won't convert files to use extents.  Once you set the
> extents flag, new files that are created will be created with extents,
> but existing files are left untouched.  

Mmmm. I had some big files on my drive, and some of them now use
only 1 extent and some 2. I supposed that fsck.ext4 recognized a
run of contiguous blocks and turned the list of inodes onto one
and only extent:

werewolf:/mnt/dsk0/music/zzz# ll
total 121760
-rw-r--r-- 1 magallon home 21892759 2008.03.02 23:30 01 zzz.mp3
-rw-r--r-- 1 magallon home  7192808 2008.03.02 23:30 02 zzz.mp3
-rw-r--r-- 1 magallon home  6709136 2008.03.02 23:30 03 zzz.mp3
-rw-r--r-- 1 magallon home  7155107 2008.03.02 23:30 04 zzz.mp3
-rw-r--r-- 1 magallon home 10457465 2008.03.02 23:30 05 zzz.mp3
-rw-r--r-- 1 magallon home  6082273 2008.03.02 23:30 06 zzz.mp3
-rw-r--r-- 1 magallon home 10052444 2008.03.02 23:30 07 zzz.mp3

werewolf:/mnt/dsk0/music/zzz# filefrag *
01 zzz.mp3: 1 extent found
02 zzz.mp3: 1 extent found
03 zzz.mp3: 1 extent found
04 zzz.mp3: 1 extent found
05 zzz.mp3: 2 extents found, perfection would be 1 extent
06 zzz.mp3: 1 extent found
07 zzz.mp3: 2 extents found, perfection would be 1 extent

But I have just discovered that filefrag also works on ext3, so
it has not so much meaning...

> Also, some of ext4's
> performance improvements will only come after doing a
> dump/mke2fs/restore pass.  People who are thinking about doing that
> would be advised to wait until after 2.6.30 or 2.6.31, though, since
> we have a patch that changes how the block/inode allocator works
> currently pending in development.
> 
> Eventually, I hope the online defragger will be able to fully convert
> an ext3 filesystem to use extents, with files defragged and placed in
> locations that is as close as possible to a dump/mke2fs/restore pass
> --- but we're not there yet.  Obviously you'll get a some of the
> performance improvements simply going to ext4, and more by enabling
> various ext4 features, such as extents et. al.  But for example, the
> defragger still tries to keep blocks in the same block group, and it's
> not aware of the new allocation policies that tries to keep inodes and
> blocks within the same flex_bg (which is a collection of block
> groups).  So that's an example of how the defragger needs to be made
> more intelligent, and that work hasn't happened yet.
> 

Many thanks forr the info !!

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
