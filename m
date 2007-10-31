Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXJaHLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXJaHLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXJaHLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:11:36 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:45634 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752961AbXJaHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:11:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DqohUjjXt1+Dqopz5pqCnwT4BDFej4Oit6h8626okb3GvehBSHAVPA6z0263Acp0NgjFExIGHOQD8ExpGhj0jVpTA3amseuVqpWWtomsOBvMJkWqR2+xNVH9EoZMX14OZF75Wymrrpj1lyvkku6ARzU+IqnKzsOFYC09S4EcLKk=  ;
X-YMail-OSG: aEmpZYsVM1m9Fw67iW1HfKRA_iKewAwG.AjAG.bUP2TqJdCB.._Vp2CDRCnsQIyJCFINoAyIuA--
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Wed, 31 Oct 2007 00:11:33 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <200710301305.02640.david-b@pacbell.net> <1193813431.6971.24.camel@roc-laptop>
In-Reply-To: <1193813431.6971.24.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710310011.33545.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, Bryan Wu wrote:
> Maybe there are some confusion of mixing up the spi_trasnfer.speed_hz
> with the spi_device.max_speed_hz.
> 
> spi_device.max_speed_hz comes from spi_board_info.max_speed_hz, it is
> for the default max speed value.

It's initialized from board_info, yes.  Drivers can override it
using spi_setup().

One would expect they only override _downwards_ but that's not
guaranteed anywhere.  A driver might have a way to establish that
this particular board can run faster, for example.


> spi_transfer.speed_hz comes from upper applications for each spi
> transfer setting.

Certainly; all spi_transfer records come from applications!
If that value is zero, that transfer segment uses the limit
from the spi_device ... otherwise, it can differ.  Again,
the limits can vary based on devise characteristics; maybe
it can't feed data as fast for some commands.

(ISTR the M25P16 in $SUBJECT has two read commands, one of
which is only usable at clock rates below 33 MHz or so, but
most other commands can work above that speed just fine.)

- Dave
