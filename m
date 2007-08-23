Return-Path: <linux-kernel-owner+w=401wt.eu-S1765933AbXHWVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765933AbXHWVyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXHWVyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:54:41 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:46129 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761454AbXHWVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:54:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZaExSnicR0ls2ytdCaXMQPnczLHRxG98vWIzaT+jATlr8gF3dz2N9uQoua1hRZwpsVlZXEC/DlkQaokZqvjrHuASaSBRLoCV1NTIlXwgsywNZ2HMktACLUImt1+jU/Fk/Ju9G1r1hBVhyfEbkSoa6y6INmvj00gBqubtTd6ACtM=  ;
X-YMail-OSG: q7r8wwQVM1kf2W7A0RQwBxn_c9wXP4ooD3cmJ0Il5KwvWdjW7CJpGZjB6BHg5m7UOBGJIdyrqQ--
From: David Brownell <david-b@pacbell.net>
To: Tony Jones <tonyj@suse.de>
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
Date: Thu, 23 Aug 2007 14:03:52 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
References: <20070820224806.154198000@suse.de> <200708211128.28552.david-b@pacbell.net> <20070822030515.GA32136@suse.de>
In-Reply-To: <20070822030515.GA32136@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708231403.52846.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007, Tony Jones wrote:
> I believe this is the necessary documentation changes.

Thanks.  I have an update, plus updates for the mmc_spi
driver (now in MM) which you didn't update.

By the way, it's worth noting an incompatibility introduced
through these conversions and CONFIG_SYSFS_DEPRECATED=n:

 - previously .../controller/spi_master:spi2 would be a
   symlink to /sys/class/spi_master/spi2

 - now, /sys/class/spi_master/spi2 is a symlink to
   .../controller/spi_master (with DEPRECATED=n).

The symlink direction is just noise ... the issue is that with
this approach it's no longer possible to have one controller
handle multiple SPI busses!  A fix would involve maintaining
the original "spi_master:spi2" name.

I don't happen to know of such a controller, and one would
surprise me a bit.  Exactly like the fact that several I2C
adapters work that way was a surprise:  one PCI function
controlling several different I2C busses, rather than one
function per bus.

- Dave

