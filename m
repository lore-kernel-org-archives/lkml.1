Return-Path: <linux-kernel-owner+w=401wt.eu-S935096AbZKYXWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096AbZKYXWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934896AbZKYXWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:22:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:24898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934859AbZKYXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:22:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m3u5tPD9RRty31nMgjU0Xv+BAxELG4p7GXk3PZ8JvVEJVLGXIf7gLjfZKZQqzfeed3
         8w0PP3oMr19fq3wy4BQbzmRLSZIkv5K4nIGq9UFAsd6fqj2CPLVwoo+5Kkn0X0H7ROfx
         SZdeCK8x6yfZst97W9sW2tTizPq3ryX8VtTBM=
Subject: Re: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091125205942.GF10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop>
	 <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org>
	 <1259155258.4875.17.camel@maxim-laptop> <20091125153458.GC10944@logfs.org>
	 <1259165866.10147.35.camel@maxim-laptop> <20091125205942.GF10944@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 01:22:45 +0200
Message-ID: <1259191365.15916.31.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 21:59 +0100, Jörn Engel wrote: 
> On Wed, 25 November 2009 18:17:46 +0200, Maxim Levitsky wrote:
> > On Wed, 2009-11-25 at 16:34 +0100, Jörn Engel wrote: 
> > > 
> > > Those are card readers built into notebooks, right?  How are they
> > > attached?  Via PCI or USB?
> > Mostly in notebooks.
> > External readers usually implement standard mass-storage protocol.
> 
> Ok.  I guess I won't buy a new notebook just to test a driver then.
> 
> > They are usually PCI , however some USB devices work the same, for
> > example
> > alluda device that currently has two drivers in the kernel, one mtd for
> > raw access, and another self-contained USB driver that does FTL and
> > exposes device as an SCSI device.
> 
> Yes.  I've written the mtd driver for that one.
> 
> > > It has been a while since I looked at the spec, but I believe there are
> > > two parts to it.  The flash hardware allows block erases, sector reads
> > > and sector writes.  On top of that you have the FTL that adds further
> > > restrictions.
> > if this is the case, then no problems.
> > Alex said something about firmware bugs though, that I belive is
> > connected to raw block writes.
> > 
> > I also know that driver for my ricoh based controller does always block
> > based cow writes.
> 
> If you only ever want to use the device with the FTL on top, that is
> perfectly acceptable.  But it is an FTL restriction, not part of the
> hardware.  Apart from firmware bugs, of course.
Exactly.

> 
> > when I say block I mean area that can be erased independently, and it
> > consists of several 512 byte sectors.
> > (Very old incarnation of smartmedia format had 256 byte sectors that
> > were tied together in pairs)
> 
> Some also had 256 or 512 blocks per zone.  These days everything seems
> to have 512+16 Byte sectors, 16 sectors per block, 1024 physical (1000
> logical) blocks per zone and as many zones as the device can fit.  Or at
> least that was the case two years ago.
Yes that the same I see.

> 
> > > Format and rescue certainly make sense.  I'm not sure how a debug
> > > application would measure the health, but maybe that's possible as well.
> > I can count bad sectors, ecc corrected sectors, see how many spares
> > remain in each block, etc...
> 
> Iirc the number of bad blocks never changes.  Either a block is
> factory-marked or it will stay in use forever.  A smart FTL could try to
> store the erase count or the number of correctable/uncorrectable errors
> for each block somewhere, but I don't believe it is done - or could be
> done while staying compatible with the xD spec.

> 
> So that pretty much leaves the number of correctable/uncorrectable
> errors currently on the device.
Exactly.

> 
> > > That would be available when using mtdchar or mtdblock to read the
> > > device.  Which ought to be enough for format, rescue and debug, I
> > > believe.
> > 
> > Yes this is enough, but how I expose media type in the mtd driver, there
> > is a field for that I missed?
> > 
> > And same question for the ID.
> > 
> > Note that media type /ID is _not_ stored on the media (well it is but is
> > not accessible that way)
> > There is need for special command to read it from the device.
> 
> Right.  I forgot about that one.  In fact, I tried fairly hard to
> forget. ;)
> 
> According to FMTP140E.PDF, CIS and IDI are stored in sector 0 or the
> first non-defective block.  In other words, it can be read and written
> normally, without any magic.  Certainly not the atrocities I tried not
> to remember.
I wish I had the spec.
I don't know the format of the CIS, and I know that special command is
used to query the ID.
CIS these days isn't used for anything and I hoped not to touch that
thing.

I wont argue on that one with you, but why not to add the new field.
It is quite generic, it could be card vendor information or so?
Few bits of custom information to assign for each card no?


I am taking about these:

struct xd_card_id1 {
unsigned char maker_code;
unsigned char device_code;
unsigned char option_code1;
unsigned char option_code2;
} __attribute__((packed));

struct xd_card_id2 {
unsigned char characteristics_code;
#define XD_CARD_CELL_TYPE_MASK   0xc0
#define XD_CARD_MULTI_BLOCK_MASK 0x30

unsigned char vendor_code1;
unsigned char size_code;
unsigned char vendor_code2;
unsigned char vendor_code3;
} __attribute__((packed));

struct xd_card_id3 {
unsigned char vendor_code1;
unsigned char vendor_code2;
unsigned char id_code;
unsigned char vendor_code3;
} __attribute__((packed));


Are these 32 bit values copied from CIF?

These values are read using commands:

XD_CARD_CMD_ID1         = 0x90,
XD_CARD_CMD_ID2         = 0x91,
XD_CARD_CMD_ID3         = 0x9a


I need especially the xd_card_id1.device_code because this specifies the
media type, but xd_card_id3.id_code is used to detemine if media is
smartmedia or XD.

Best regards,
Maxim Levitsky

