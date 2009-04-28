Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZD1J2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZD1J2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZD1J2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:28:11 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:47597 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754058AbZD1J2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:28:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JevmUMXEj9DiLSJQTQNZTzFUYE6cVhZCKCbx+fRtAk4Xz2OIPPLzKuqB2qhUI5AlNJOGmxZewt8aT2WLiKyqH/GvdYWXSyaXN2hx21gT0Woh7UbcQW6IdoahoN9GZYxL4pjIMedz9YDsuD8odRs4/QUue5tCdemGykvOG6MrCFY=  ;
X-YMail-OSG: cpAWSWEVM1lGrU3ll2f2HsKfH7FoWQx1kcFvj3L.DFlrIT7m9yV7hUhLXlVxCKN2SEgc3JTLsHMWpHNFnEQFIEEVGmm.YJXZjCIJu9vckLvKi4JV7E.PdFtvkqRhOVdFFwvJYTs7zFhiZtVusYmFmUNhSbl7p3Z615ECLouufvBMAw20PhKfv1TFG3J4Q3fn8ne0FNv7hqwzK3bHGYXCb0.DofKY5h17_OGN2JXOEmUkJH7PxM3CIC8dLIOvuZBpRBlX1ec2g_K84nh2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.30-rc3] platform_bus:  remove "which platform_data?" confusion
Date: Tue, 28 Apr 2009 02:28:07 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200904271943.40588.david-b@pacbell.net> <20090428050742.GB17432@kroah.com>
In-Reply-To: <20090428050742.GB17432@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904280228.07346.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No comment on the bugfix part of $SUBJECT patch?


On Monday 27 April 2009, Greg KH wrote:
> 
> > Those patches seem to support what I think is a misguided
> > notion:  that somehow device.platform_data might move into
> > the platform_device.  The problem with that idea is that it's
> > a general purpose hook, and is used by other busses to provide
> > board-specific configuration data ... not just for platform_bus.
> 
> It is?  What other busses do this?

SPI and I2C come quickly to mind...

Basically, *any* bus that could ever be used on an embedded
system may need platform_data to explain how each discrete
chip has been wired up on that particular board.  Very few
such busses can self-enumerate like PCI or USB.  And most of
the chips sitting on such busses expect to interface to fairly
random external hardware.

And come to think of it, I've seen cases with PCI and USB
where board-specific config data is needed.  PCI doesn't
always wrap it up in some ACPI bytecode, and sometimes USB
devices use "transceiverless link" hookup, so the board
can just hook up using a differential pair.

SDIO/MMC doesn't tend to need it though, even for SDIO
WLAN or MMC/SD storage links (eMMC, CE-ATA, etc).


> And why, can't they use their own bus private data pointers?

ENOPATCH.  ;)

Though ... since devices on *any* bus may need this, I
don't much see the point of modifying every bus like that.

- Dave



