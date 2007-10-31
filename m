Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbXJaHf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbXJaHf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXJaHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:35:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:47218 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbXJaHfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:35:14 -0400
X-IronPort-AV: i="4.21,350,1188792000"; 
   d="scan'208"; a="42762811:sNHT33061315"
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with
	SPI flash ST25P16 on bf548
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: bryan.wu@analog.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <200710310011.33545.david-b@pacbell.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <200710301305.02640.david-b@pacbell.net>
	 <1193813431.6971.24.camel@roc-laptop>
	 <200710310011.33545.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 31 Oct 2007 15:35:10 +0800
Message-Id: <1193816110.6971.50.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 31 Oct 2007 07:35:13.0157 (UTC) FILETIME=[92C34350:01C81B90]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 00:11 -0700, David Brownell wrote:
> On Tuesday 30 October 2007, Bryan Wu wrote:
> > Maybe there are some confusion of mixing up the spi_trasnfer.speed_hz
> > with the spi_device.max_speed_hz.
> > 
> > spi_device.max_speed_hz comes from spi_board_info.max_speed_hz, it is
> > for the default max speed value.
> 
> It's initialized from board_info, yes.  Drivers can override it
> using spi_setup().
> 
> One would expect they only override _downwards_ but that's not
> guaranteed anywhere.  A driver might have a way to establish that
> this particular board can run faster, for example.
> 

IMO, the spi_transfer.speed_hz <= spi_board_info.max_speed_hz and if
spi_trasnfer.speed_hz is 0, we should use spi_board_info.max_speed_hz.
>From the meaning of max_speed_hz, the spi_transfer.speed_hz should not
beyond max_speed_hz.

In your explanation, the max_speed_hz is just a default value. the
transfer speed_hz can beyond max_speed_hz. We found the bug in M25P16
should be related this missing checking of the transfer  speed_hz.

> 
> > spi_transfer.speed_hz comes from upper applications for each spi
> > transfer setting.
> 
> Certainly; all spi_transfer records come from applications!
> If that value is zero, that transfer segment uses the limit
> from the spi_device ... otherwise, it can differ.  Again,
> the limits can vary based on devise characteristics; maybe
> it can't feed data as fast for some commands.
> 
> (ISTR the M25P16 in $SUBJECT has two read commands, one of
> which is only usable at clock rates below 33 MHz or so, but
> most other commands can work above that speed just fine.)
> 
OK, We check it on Blackfin board.
-Bryan Wu
