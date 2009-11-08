Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZKHI3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZKHI3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZKHI3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:29:05 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:51471 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438AbZKHI3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:29:05 -0500
Date: Sun, 8 Nov 2009 19:29:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Daniel Pittman <daniel@rimspace.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
	s2disk/ram cycle
Message-ID: <20091108082905.GA25494@discord.disaster>
References: <87vdisq7bh.fsf@rimspace.net> <20091007161604.GA28849@infradead.org> <20091104111125.54C3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104111125.54C3.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 11:18:05AM +0900, KOSAKI Motohiro wrote:
> > On Wed, Oct 07, 2009 at 01:14:10PM +1100, Daniel Pittman wrote:
> > > For what it is worth, I would also be quite interested to know
> > > /why/ XFS is bad in this regard.  Is it just the previously
> > > stated "XFS writes to disk despite freezing kernel threads"
> > > issue, or something deeper?
> > 
> > sync pushes out all data to disk, but in a journaling filesystem
> > that might just but the log not the "normal" place on disk.  For
> > a boot loader to deal with it properly it actually needs to do
> > an replay of the log.  Grub does so for reiserfs but not for XFS
> > for some reason.  I don't know why problems don't trigger more
> > often with ext3, though.
> 
> I'm sorry for the long delayed and offtopic responce. I discussed
> this issue with okuji-san (GRUB2 maintainer) at several month ago.
> He really wish linux implement real sync.
> 
> A bootloader has much constraint than OS (mainly caused by size
> constraint).  it can't implemnt jornal log replay logic for _all_
> filesystem.  Why can't we implement storong sync syscall? I don't
> think this is PM nor bootloader fault.

We already have an ioctl that does what you want: FIFREEZE.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
