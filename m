Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXJaGur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXJaGur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXJaGuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:50:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4976 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXJaGui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:50:38 -0400
X-IronPort-AV: i="4.21,350,1188792000"; 
   d="scan'208"; a="42761156:sNHT29138998"
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with
	SPI flash ST25P16 on bf548
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <200710301305.02640.david-b@pacbell.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <1193735885-8202-10-git-send-email-bryan.wu@analog.com>
	 <200710301305.02640.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 31 Oct 2007 14:50:31 +0800
Message-Id: <1193813431.6971.24.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 31 Oct 2007 06:50:36.0960 (UTC) FILETIME=[57A00200:01C81B8A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 13:05 -0700, David Brownell wrote:
> On Tuesday 30 October 2007, Bryan Wu wrote:
> > Current SPI driver enables SPI controller and set the SPI baud register
> > for each SPI transfer. But, they should never be changed within a SPI
> > message session, in which seveal SPI transfers are pumped.
> 
> That's actually not true.  If a driver sets spi_transfer.max_speed_hz
> to a nonzero value that's different from the previous bit rate (which
> may be spi_device.max_speed_hz), it should be updated before that
> transfer segment.  Example, sometimes data can't be clocked out at
> the same rate commands can be clocked in.
> 
> Similarly with spi_transfer.bits_per_word ... again, it's very possible
> that commands and data have different sizes.
> 
I agree with you here. 

Maybe there are some confusion of mixing up the spi_trasnfer.speed_hz
with the spi_device.max_speed_hz.

spi_device.max_speed_hz comes from spi_board_info.max_speed_hz, it is
for the default max speed value.
spi_transfer.speed_hz comes from upper applications for each spi
transfer setting.

Am I right?

I will fix this later.

> Of course, if those values don't change, there'd be no point in
> reconfiguring any aspect of those communications parameters...
> 
> 
> I'll be forwarding this patch, since this looks like another case
> where the main effect of the patch doesn't match its description
> and since this patch series has taken too long already.  (Does this
> patch even really relate primarily to working with an ST M25P16
> flash part??)  Though it'd be reasonable to be more hard-nosed
> about this and insist on another go-around for thesse patches.
> (Making this the fifth one??)
> 
> But I *STRONGLY* suggest someone revisit the issue of whether those
> two per-transfer options are now being handled correctly.  As well
> as update procedures so that the patch comments start to have a
> direct correspondence to what the patches have changed...
> 

OK, we will test this on our hardware.
Thanks, Dave
-Bryan Wu
