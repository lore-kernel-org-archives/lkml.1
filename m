Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZAFGVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZAFGVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZAFGVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:21:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZAFGVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:21:15 -0500
Date: Mon, 5 Jan 2009 22:19:46 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: debugfs & vfs file permission issue?
Message-ID: <20090106061946.GA10026@suse.de>
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <20090106054858.GA9040@suse.de> <8bd0f97a0901052154w213f9a03oafdd07645b1b7dc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0901052154w213f9a03oafdd07645b1b7dc7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:54:58AM -0500, Mike Frysinger wrote:
> On Tue, Jan 6, 2009 at 00:48, Greg KH wrote:
> > On Mon, Jan 05, 2009 at 09:57:07PM -0500, Robin Getz wrote:
> >> On 2.6.28-rc2, If I create a debugfs file with
> >>
> >>     debugfs_create_x16("SPORT1_TX", 0200 , parent, 0xFFC00910);
> >
> > Um, are you are passing in a pointer to a known memory location
> > properly?  Why would it be ok for the kernel to directly read that
> > location?
> 
> it's a nommu system and the 0xffc00000+ addresses are always available

Writable but not readable?  Isn't hardware fun :)

> >> Although the file shows up as write only (no read):
> >>
> >> root:/> ls -l /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >> --w-------    1 root     root            0 Jan  1
> >> 2007 /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >>
> >> root:/> cat /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >>
> >> Still works - and causes the read to occur, which crashes :(
> >
> > You're root, you can do anything :)
> 
> any thoughts on how to declare debugfs files that are read or write
> only ?  we'll have to add new helper functions or have it be a
> parameter or declare our own debugfs file ?

Just use debugfs_create_file() and use your own read/write functions to
prevent a read or write from happening no matter what.  No new debugfs
infrastructure should be needed.

good luck,

greg k-h
