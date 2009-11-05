Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZKEJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZKEJ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZKEJ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:56:36 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42260 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbZKEJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:56:35 -0500
X-Sasl-enc: yXTSF8ke87eTjBHxYMg0h8VPyy9TJEpKbIv8XKtT/NL6 1257414999
Date: Thu, 5 Nov 2009 07:56:37 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Daniel Pittman <daniel@rimspace.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
 s2disk/ram cycle
Message-ID: <20091105095637.GG30649@khazad-dum.debian.net>
References: <87vdisq7bh.fsf@rimspace.net>
 <20091007161604.GA28849@infradead.org>
 <20091104111125.54C3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104111125.54C3.A69D9226@jp.fujitsu.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Nov 2009, KOSAKI Motohiro wrote:
> > On Wed, Oct 07, 2009 at 01:14:10PM +1100, Daniel Pittman wrote:
> > > For what it is worth, I would also be quite interested to know /why/ XFS is
> > > bad in this regard.  Is it just the previously stated "XFS writes to disk
> > > despite freezing kernel threads" issue, or something deeper?
> > 
> > sync pushes out all data to disk, but in a journaling filesystem that
> > might just but the log not the "normal" place on disk.  For a boot
> > loader to deal with it properly it actually needs to do an replay of
> > the log.  Grub does so for reiserfs but not for XFS for some reason.
> > I don't know why problems don't trigger more often with ext3, though.
> 
> I'm sorry for the long delayed and offtopic responce. I discussed this
> issue with okuji-san (GRUB2 maintainer) at several month ago.
> He really wish linux implement real sync.

This is not about real sync.  It is about the box being able to reboot after
a crash or power failure.

GRUB2 is broken in that regard, at least in its peecee-BIOS version:  last
time I checked, it doesn't sort RAID components so that it won't boot from
failed or out-of-sync older components, it can't deal with some of the
filesystems being unclean...

> A bootloader has much constraint than OS (mainly caused by size constraint).
> it can't implemnt jornal log replay logic for _all_ filesystem. Why can't we
> implement storong sync syscall? I don't think this is PM nor bootloader fault.

A bootloader that can't boot a system that went through an unclean shutdown
is quite broken.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
