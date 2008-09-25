Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYIYKGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYIYKGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYIYKFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:05:55 -0400
Received: from mail.transmode.se ([83.241.175.147]:15537 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYIYKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:05:55 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Ben Nizette <bn@niasdigital.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1222297057.4037.12.camel@moss.renham>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
	 <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
	 <1222297057.4037.12.camel@moss.renham>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Thu, 25 Sep 2008 12:05:51 +0200
Message-Id: <1222337151.12624.293.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 08:57 +1000, Ben Nizette wrote:
> On Wed, 2008-09-24 at 14:38 +0200, Joakim Tjernlund wrote:
> > On Wed, 2008-09-24 at 20:47 +0900, Paul Mundt wrote:
> > > > 
> > > Nonsense, there is nothing wrong with UIO's interface as it is today.
> > > It is no different from sound cards, cdroms, and so on. If you want the
> > 
> > It is different, cdroms and audio are named differently. If they were
> > using UIO they would all be named /dev/uio%d.
> > 
> > Consider uio_cif and uio_smx, is it impossible to image that such
> > devices could use another name such as crypto_smx%d instead?
> > 
> 
> My system does use uio_smx and uio_pdrv, they both appear as /dev/uioX.
> This to me is just like having /dev/hda, /dev/hdb rather
> than /dev/myrootpartition, /dev/somebackupspace or whatever.  In this
> case you do have a /dev/cdrom symlink but it's just that, a symlink set
> up by scripts.  The kernel doesn't (and shouldn't) make that naming
> decision for you.
> 
> My software just walks /sys/class/uio/uioX/name, finds the one which
> matches then opens the corresponding device.  No scripts needed, no
> in-kernel hackery or policy making, just the interface used as the maker
> intended.  What's your problem with this approach?

My problem is this, uio is a generic container for any user space device
and by itself it doesn't mean much. You put some protocol driver on top
of uio, such as uio_smx, to make it mean something. 

Comparing uio with hdX is wrong as hdX means something, it is a block
device for a disk. 
A better comparison would be if all kernel devices were named kio%d and
you had to scan /sys to find the name hdX.

Look at the spi subsystem, the protocol drivers name them self.

 Jocke
