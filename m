Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZD2FCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZD2FCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZD2FCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:02:04 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:36654 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751472AbZD2FCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:02:03 -0400
X-Yahoo-Newman-Id: 569636.98583.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M88Zbgl0CsgERJl4bQPqst00RkWInISTlYKBhJTTzHRohJQ5CX87mBi5AwvnvPyPMrwo1X/2Byi4EEMiW3AYzvTMarto2I2+uatIuB9Ngx6SatMn6B5YNQKjfmwWnSY4nsYwCQ4thh5CJc9NoF2bBadnFFd72qWyzLwuI8XemAQ=  ;
X-YMail-OSG: zJdONv8VM1mCGMoUh9hzYY5rE37EPOAiqbFAQKqxcIHZJR53zLeWbPip2quaZMWV.tRF36jGZqrZgJbmlIuprL.KB36j8qx_uNWYoMD2S3nNtZtDD1nJicgrcaTJRb0Kmx2XErDmfGi30z0ppW3XQDG2FFJdipYsbcrpPMp1LHrrRS3azoYx2zqxeDboRvQ.R3pEAXdJXKGRqAuSG9YA5i44oGi47ucekXZicugwTfqA7_Zt9hBwHuKt3TPE1ONwd7RmjMJqphqXuQCI
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.30-rc3] platform_bus:  remove "which platform_data?" confusion
Date: Tue, 28 Apr 2009 22:01:59 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200904271943.40588.david-b@pacbell.net> <200904280228.07346.david-b@pacbell.net> <20090429032446.GC23062@kroah.com>
In-Reply-To: <20090429032446.GC23062@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904282201.59649.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Greg KH wrote:
> On Tue, Apr 28, 2009 at 02:28:07AM -0700, David Brownell wrote:
> > No comment on the bugfix part of $SUBJECT patch?
> 
> Well, no, I'm assuming it is correct :)
> 
> Should I just revert the original change, if the fact that busses are
> using the platform_data field?

That would be my inclination.


> > On Monday 27 April 2009, Greg KH wrote:
> > > 
> > > > Those patches seem to support what I think is a misguided
> > > > notion:  that somehow device.platform_data might move into
> > > > the platform_device.  The problem with that idea is that it's
> > > > a general purpose hook, and is used by other busses to provide
> > > > board-specific configuration data ... not just for platform_bus.
> > > 
> > > It is?  What other busses do this?
> > 
> > SPI and I2C come quickly to mind...
> > 
> > Basically, *any* bus that could ever be used on an embedded
> > system may need platform_data to explain how each discrete
> > chip has been wired up on that particular board.  Very few
> > such busses can self-enumerate like PCI or USB.  And most of
> > the chips sitting on such busses expect to interface to fairly
> > random external hardware.
> > 
> > And come to think of it, I've seen cases with PCI and USB
> > where board-specific config data is needed.  PCI doesn't
> > always wrap it up in some ACPI bytecode, and sometimes USB
> > devices use "transceiverless link" hookup, so the board
> > can just hook up using a differential pair.
> > 
> > SDIO/MMC doesn't tend to need it though, even for SDIO
> > WLAN or MMC/SD storage links (eMMC, CE-ATA, etc).
> > 
> > 
> > > And why, can't they use their own bus private data pointers?
> > 
> > ENOPATCH.  ;)
> > 
> > Though ... since devices on *any* bus may need this, I
> > don't much see the point of modifying every bus like that.
> 
> Fair enough, no objection from me.
> 
> thanks,
> 
> greg k-h
> 
> 



