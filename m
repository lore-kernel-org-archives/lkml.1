Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZKYKkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZKYKkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZKYKkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:40:32 -0500
Received: from lazybastard.de ([212.112.238.170]:44989 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbZKYKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:40:31 -0500
Date: Wed, 25 Nov 2009 11:40:27 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
Subject: Re: Plan for adding XD support in mtd layer
Message-ID: <20091125104027.GB10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop> <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop> <1259106610.28219.34.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259106610.28219.34.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 November 2009 01:50:10 +0200, Maxim Levitsky wrote:
> 
> Chip driver:
> 
> no problems with that, in fact ricoh controller I reverse engineered is
> very similar conceptually
> to jmicron.
> I can take original jmicron driver almost verbatim.
> This will live in new sub folder of mtd and call into base XD driver

Ok.  Is the code available somewhere or can you send it?  And what
devices would one have to buy to test it?

> Base XD mtd driver:
> 
> * No way to tell that readsize = 512, but write & erase size isn't.
> Not such a big deal, since higher level FTL driver can hardcode that
> assumption, and access via mtdblk isn't necessary, since FTL will
> replace it for XD, and the raw access will be done through mtdchar.
> 
> * it is possible to export 'extra' via oob. FTL will use that, and will
> be available to user via char device
> 
> * No need to export CIF block, it will be available for user via char
> device by scanning the device (using a new utility)
> 
> 
> -> I need new mtd_info member for at least for card identification, and
> will be nice to have zone/block/page size
> This will be used by FTL and mtdchar to be exported to user space

Block and page size already exist as mtd->erasesize and mtd->writesize
respectively.  I'm not sure whether the zone size should become part of
the mtd interface - it looks more like a property of the ftl.

> FTL driver:
> 
> I will write new XD/smartmedia FTL driver.
> 
> * Will read ID/type from device and do all the work based on that,
> (figure page size/zone count/block size, etc...) or will get that info
> from mtd driver 
> 
> * Will cache read/writes (this will overlap with mtdblk)
> 
> * Will provide normal block level access to filesystems, and user.
> (using common block device of course)
> 
> * No debugging information or/and device specific ioctls.
> 
> 
> Char driver:
> 
> * Already exists, and I will need to modify it, so I could read ID/media
> type
> Also would be nice to pass info about sizes (zones/pages/blocks) to
> userspace 
> If not, I will put translation table to userspace utility based on media
> ID

What userspace programs would need this information?  I can imagine some
sort of xd_format or mkxd in case the card has been corrupted or used
raw.  Anything else?

> Userspace utility:
> * Will allow user to read FTL maps (based on oob), Media ID, CIF, all
> using char device

What would this be needed for?

> * Will also allow low level format.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
