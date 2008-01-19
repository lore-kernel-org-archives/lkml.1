Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYASXWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYASXWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYASXWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:22:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42766 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYASXWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:22:24 -0500
Date: Sun, 20 Jan 2008 00:25:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steve French <smfrench@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, simo <idra@samba.org>,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: Re: [linux-cifs-client] [PATCH] Remove information leak in Linux CIFS clientg
Message-ID: <20080119232549.GA6275@one.firstfloor.org>
References: <20080119045552.GA11134@basil.nowhere.org> <1200730722.28706.70.camel@localhost.localdomain> <524f69650801191406j440e52afsb9b80efed4fa15da@mail.gmail.com> <20080119223029.GA5786@one.firstfloor.org> <524f69650801191455g5eab5edfw80f27136662a465c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650801191455g5eab5edfw80f27136662a465c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 04:55:53PM -0600, Steve French wrote:
> On Jan 19, 2008 4:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > On Sat, Jan 19, 2008 at 04:06:57PM -0600, Steve French wrote:
> > > The access denied message in the dmesg log reveals no more information
> > > than strace on stat of a local file does (which also returns access
> >
> > You can't strace a process you don't own. And you might not be able
> > to access the directory below which the file is.
> 
> If you can't access the directory that the file is in then you get
> access denied on stat of the file (local over ext3 or remote over
> cifs) - it does not tell you anything about whether the file existed
> or not.  If you do "stat
> /mnt/dir-with-0700-perm/file-which-does-not-exist"  I get access
> denied.  I don't think that it really tells you anything interesting
> since the same error comes back whether or not the file existed.

The problem is that the file name ends up in the log for everybody to
read even if they're totally unrelated. So if someone in a protected directory
tree where they have access to does something that is denied the
file names will still leak to everybody else to the log.

e.g. more concrete example. you do something and get that message.

Now even 'nobody" running in a chroot will know that you tried
that and that at least parts of the file name likely exist.

That is an information leak and imho a privacy problem.

> Other unexpected errors (e.g. -EIO) should be logged because they
> indicate possibly severe problems with the network, but also don't
> tell you anything about whether the file exists.

Sure errors should be logged, but not with path names. 

-Andi
