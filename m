Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZCaMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZCaMZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZCaMZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:25:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:38820 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZCaMZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:25:45 -0400
Date: Tue, 31 Mar 2009 08:25:40 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090331122540.GB13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903291224.21380.info@gnebu.es>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 12:24:21PM +0200, Alberto Gonzalez wrote:
> Hi,
> 
> - I use Ext4 as my filesystem (default in next Fedora release).

Fedora will have the patches so that applications that do
replace-via-truncate (a bad idea, these applications are buggy, and
will lose data sometimes even with ext3), or replace-via-rename
without the fsync(), will force the blocks out to disk with the
commit.

> - Let's say I've been working on my book for the last 14 months and I've 
> written about 400 pages on an ODF file.

Openoffice, being a portable application, that has to work on other
operating systems and filesystems (for example, like Solaris's UFS),
does do open/write/close/fsync/rename.  So you're safe if you're using
OpenOffice (and emacs, and vim).

The replace-via-truncate and replace-via-rename workarounds are there
for the benefit of KDE, and GNOME, which in some configurations
apparently will replace hundreds of dot files when the desktop is
started up, for no reason that I can understand.  (Not such a great
idea for SSD write endurance!)  Some people apparently spend hours
making sure that their windows are exactly positioned the way they
want it when their desktop starts up, and if the system crashes while
their desktop is starting up, those they could lose their window
positions, which apparently made a whole bunch of users cranky.  In
practice, most of the editors that I'm familiar with have been around
for a while, have needed to make sure that that cases such as yours
wouldn't result in data loss, and so are pretty good about using
fsync() so that users' files wouldn't be lost, no matter what the
filesystem or operating system being used.

The problem has been mostly with newer applications, especially the
newer desktop ones, which have been written to assume that they only
have to work safely on Linux and ext3.  The replace-via-truncate and
replace-via-rename workarounds provide this safety for ext4.

Best regards,

					- Ted
