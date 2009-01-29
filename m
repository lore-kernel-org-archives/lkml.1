Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZA2Ukv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZA2Ukv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZA2Ukl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:40:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51584 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753372AbZA2Ukk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:40:40 -0500
Date: Thu, 29 Jan 2009 15:40:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Jarod Wilson <jarod@redhat.com>, <linux1394-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
In-Reply-To: <49820CF9.3000706@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.0901291536020.2394-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Stefan Richter wrote:

> (adding Cc: Alan Stern just in case, because he knows much more about
> all this)
> 
> Jarod Wilson wrote:
> > On a related note... The fix capacity workaround... I think I need to
> > observe this failure myself... My own 4th-gen ipod, when connected to a
> > Mac OS X system, reports the exact capacity I get if the fix capacity
> > workaround is disabled. Do they just know not to try to access that
> > last block, or is the need for this workaround a myth? :)
> 
> Well, before the report [1] from the Ubuntu of a what appeared to be a
> regression of Ubuntu 8.10 vs. its parent or grandparent release, we
> thought we knew that iPod 2nd + 3rd gen were _not_ affected, because
> long ago an owner of these iPods told us so.
> 
> Obviously they changed something in Ubuntu 8.10 which suddenly made 3rd
> gen iPods vulnerable too.  If the report is accurate, then this is /not/
> the READ CAPACITY 10 issue where device's capacity report is off by one.
> (The reported capacity without workaround is an even number and thus
> possibly correct.)

Don't make that assumption.  One of the small number of devices which 
really did have an odd number of sectors was an early iPod.

>  Rather, this is apparently the kind of the bug where
> an access which includes the last sector corrupts some state in the
> firmware, causing the firmware to error out on subsequent accesses.  The
> actual IO errors in the reporter's log happen at low LBAs, not at LBAs
> at the end.

Are you aware of the last_sector_bug flag?  It prevents sectors near 
the end of the device from being accessed using anything other than 
single-sector reads or writes.  Some devices don't like it if, for 
example, you do a 2-sector read that includes the last sector.

> Now, what does OS X do with those iPods?  I don't know.  Maybe they have
> quirks lists like we do.  There could be something to be found in the
> Darwin sources.  But I consider it more likely that OS X simply does not
> do the kind of accesses that Linux does which tend to crash all those
> crap firmwares left and right.
> 
> Evidently, at least popular Windows incarnations don't do such accesses,
> at least not in normal usage.  Otherwise this class of firmware bugs
> could simply not exist in mass market devices.

Linux uses the last-sector accesses to check whether or not the device 
is part of a RAID.  Apparently Windows and OS X don't support the kinds 
of RAID that need this.

Alan Stern

