Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXGSIlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXGSIlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763035AbXGSIkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:40:43 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4584 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762577AbXGSIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:40:42 -0400
Date: Thu, 19 Jul 2007 10:41:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Greg KH" <gregkh@suse.de>, "Tejun Heo" <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070719104150.6c5c5165@hyperion.delvare>
In-Reply-To: <3ae72650707181744l47d6cbc6m75b7d9292959a245@mail.gmail.com>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718033828.GA8582@suse.de>
	<20070718220652.15ad2c4b@hyperion.delvare>
	<3ae72650707181744l47d6cbc6m75b7d9292959a245@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Thu, 19 Jul 2007 02:44:54 +0200, Kay Sievers wrote:
> On 7/18/07, Jean Delvare <khali@linux-fr.org> wrote:
> > On Tue, 17 Jul 2007 20:38:28 -0700, Greg KH wrote:
> > > On Tue, Jul 17, 2007 at 11:05:30PM +0200, Jean Delvare wrote:
> > > > The code looks like:
> > > >
> > > >        if (sysfs_get_mnt_path(sensors_sysfs_mount, NAME_MAX)
> > > >          || stat(sensors_sysfs_mount, &statbuf) < 0
> > > >          || statbuf.st_nlink <= 2)      /* Empty directory */
> > > >                 return 0;           /* Failure */
> > > >
> > > > This works OK with 2.6.22.1, but the last test fails with the current
> > > > git kernel even when sysfs is mounted.
> > >
> > > Yeah, but is checking the number of hard links in the directory a safe
> > > way to always verify that it isn't empty?
> >
> > I think so, yes. To the best of my knowledge, it has worked on all
> > Unix-like systems for decades. There are other ways, but this is by far
> > the less expensive.
> 
> Well, just check if /sys/devices/ exists, that should be cheap enough. :)

Yes, this is a possibility, and one I had considered at first. But I
wasn't sure which subdirectory to check. sysfs isn't well known for its
stability, and I didn't know which directories exist since the
early days of sysfs, and which do not. For example, fs, kernel and
module were not present in 2.6.5. I am also not sure if directories
which exist today are guaranteed to exist forever. This is the reason
why I decided to check the link count instead, basically checking that
at least one subdirectory exists, without having to name it.

-- 
Jean Delvare
