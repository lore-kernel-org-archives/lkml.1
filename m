Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbZAHTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbZAHTOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZAHTOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:14:06 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42306 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZAHTOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:14:03 -0500
Date: Thu, 8 Jan 2009 20:11:53 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20090108191152.GU15123@enneenne.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151915.df138883.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106151915.df138883.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: 2.6.29 -mm merge plans
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:19:15PM -0800, Andrew Morton wrote:
> (cc's added)
> 
> On Tue, 6 Jan 2009 17:57:44 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > 
> > > linuxpps-core-support.patch
> > 
> > looks generally good, but the comments should get a little loving.
> > Please remove the stupid filenames that always get out of sync in
> > the top of file comments, and make the documentation of exported
> > symbols kernel-doc instead of it's weird own format.

With "kernel-doc" do you mean what explained into
Documentation/kernel-doc-nano-HOWTO.txt file?

> > Does checkpatch.pl still not catch these things?

No... checkpatch.pl reports everything OK.

> > Also the ioctl certainly should be an unlocked_ioctl and not the
> > old BKL-locked variant. The !uarg checks in the ioctls can go,
> > copy_to/from_users does this automatically.
> > 
> > pps.h shoulkd be split into one header only defining the
> > kernel<->userspace ABI, and a kernel-internal one.  That way
> > also the conditional includes can go away.

I don't understand well what I should do here... I supposed __KERNEL__
define was defined to allow mixing kernel and userland code.

> > > pps-documentation-programs-and-examples.patch
> > 
> > Once again this stuff is in and utterly wrong place where it can't
> > easily be package for distros.  ppsfind belongs into util-linux and
> > needs a proper mangage, ppsldisc is not nessecary but ldattach in
> > util-linux needs to grow support for N_PPS instead, and ppstest
> > should probably go into util-linux in a more polished version, too.

Regarding ldisc support we should ask to Alan which solution he
preferes: ldisc & N_PPS or setserial & HARDPPS.

However I suppose is better having the LinuxPPS's core inclusion and
then solve the serial support issue.

> > > pps-userland-header-file-for-pps-api.patch
> > 
> > This one is utterly wrong.  It provides what should be a userspace
> > library as inlines in a kernel header. 
> > 
> > Please do a proper libpps library package.
> 
> Well that's a drop-it-all-and-start again scale of thing.

I think so... :'(

> Rodolfo, do you have sufficient information here?

I'll start changing the code ASAP and I'll ask to you if something
will be still obscure to me. :)

Thanks for your help and time,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
