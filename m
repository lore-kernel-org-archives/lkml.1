Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXHZTy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXHZTy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 15:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXHZTyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 15:54:18 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:37402 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751401AbXHZTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 15:54:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zu6sqXOQX9Vdb9ww7SWXKVEt2G8HPtRJlfHjg+F7Geki0zhREcX3eBM3c5ntdBDCMaGbWwF6HkHZ8ieZQfoegCc4Qrn/KWIpvFlfGI5do1PwVd1VBct4UVvVKKvtByl6fCqBCW7iqktk8drZiPROhZagmAh2h9ZPvvOSmYCq2f0=  ;
X-YMail-OSG: XUBgFTkVM1nJ8HRevXgpx8_m7m3uHlRIUM6N2zczxRl4_NwrBj1DeNPMStdzXptNoNR6Bh2qdA--
From: David Brownell <david-b@pacbell.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
Date: Sun, 26 Aug 2007 12:54:14 -0700
User-Agent: KMail/1.9.6
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org
References: <20070820224806.154198000@suse.de> <200708231403.52846.david-b@pacbell.net> <1187907172.3632.43.camel@lov.localdomain>
In-Reply-To: <1187907172.3632.43.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708261254.14641.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007, Kay Sievers wrote:
> On Thu, 2007-08-23 at 14:03 -0700, David Brownell wrote:
> > On Tuesday 21 August 2007, Tony Jones wrote:
> > > I believe this is the necessary documentation changes.
> > 
> > Thanks.  I have an update, plus updates for the mmc_spi
> > driver (now in MM) which you didn't update.
> > 
> > By the way, it's worth noting an incompatibility introduced
> > through these conversions and CONFIG_SYSFS_DEPRECATED=n:
> > 
> >  ...
> >  
> >  - now, /sys/class/spi_master/spi2 is a symlink to
> >    .../controller/spi_master (with DEPRECATED=n).
> 
> Ugh! Are you sure, that is doesn't point to:
>   .../controller/spi_master/spi2/ ?

Turns out that it does -- once you tell Minicom to change its
bogus default of discarding data rather than line wrapping!
Which means there can still be multiple class instances that
get coupled to a given physical device; no lossage there.

Sigh.  It's hard sometimes to remember to apply all the
right bug workarounds, when some of them are in userspace.

Still, that's a needless incompatibility.  Why isn't that
pointing to a .../controller/spi_master:spi2 directory,
so that the pathnames don't change (only symlink polarity)?

- Dave
