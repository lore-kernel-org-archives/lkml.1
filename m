Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbZDER1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbZDER1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZDER1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:27:12 -0400
Received: from mail001.aei.ca ([206.123.6.130]:47679 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZDER1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:27:11 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Sun, 5 Apr 2009 13:27:03 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.29-gentoo-r1-crc; KDE/4.2.1; x86_64; ; )
Cc: Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu>
In-Reply-To: <20090331122540.GB13356@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904051327.04227.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 08:25:40 Theodore Tso wrote:
> On Sun, Mar 29, 2009 at 12:24:21PM +0200, Alberto Gonzalez wrote:
> > Hi,
> >
> > - I use Ext4 as my filesystem (default in next Fedora release).
>
> Fedora will have the patches so that applications that do
> replace-via-truncate (a bad idea, these applications are buggy, and
> will lose data sometimes even with ext3), or replace-via-rename
> without the fsync(), will force the blocks out to disk with the
> commit.
>
> > - Let's say I've been working on my book for the last 14 months and I've
> > written about 400 pages on an ODF file.
>
> Openoffice, being a portable application, that has to work on other
> operating systems and filesystems (for example, like Solaris's UFS),
> does do open/write/close/fsync/rename.  So you're safe if you're using
> OpenOffice (and emacs, and vim).
>
> The replace-via-truncate and replace-via-rename workarounds are there
> for the benefit of KDE, and GNOME, which in some configurations
> apparently will replace hundreds of dot files when the desktop is
> started up, for no reason that I can understand.  (Not such a great
> idea for SSD write endurance!)  Some people apparently spend hours
> making sure that their windows are exactly positioned the way they
> want it when their desktop starts up, and if the system crashes while
> their desktop is starting up, those they could lose their window
> positions, which apparently made a whole bunch of users cranky.  In
> practice, most of the editors that I'm familiar with have been around
> for a while, have needed to make sure that that cases such as yours
> wouldn't result in data loss, and so are pretty good about using
> fsync() so that users' files wouldn't be lost, no matter what the
> filesystem or operating system being used.

Its more than losing window postions.  I've been using ext4 with kde 4.2.1 
along with some experimental modules (drm for xorg for r600 support, btrfs) 
and a few patches.  As expected this has caused a few crashes.  I have had 
kde lose desktop setup info (eg. it forgot it was using xrender accel).  I 
have also had kmail lose all its configuration - which is a pita to rebuild.  
Note that these crashes occur long after kde has been started...

> The problem has been mostly with newer applications, especially the
> newer desktop ones, which have been written to assume that they only
> have to work safely on Linux and ext3.  The replace-via-truncate and
> replace-via-rename workarounds provide this safety for ext4.

When there are patches out to improve this (bad) behavior I would love
to try them.

TIA
Ed Tomlinson
