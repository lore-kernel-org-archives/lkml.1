Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXJ3UYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXJ3UYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXJ3UYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:24:24 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44651 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002AbXJ3UYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:24:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AUpBWJogZ2i349jsjjEEDxKn3jfnz4CdWOIVm164KF7sdco4zaPNTDo+Tom2zK++nT+tYNgGc7TWaArALU26QOwyMn4TvtGCLDB/Xw9OeQtderQTEo3oOy1X0HP0UVDYdlr5RADSHh1rxy78U0ZLbPnLvFwV8j4voafBxGiSHJY=  ;
X-YMail-OSG: 1xv8KaEVM1kKa00hBydzH8rgUVS.topdUkad0z1Y4Q.81Wjh7ZAYpUsMGc3_63GoPVYaqzVpyQ--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Tue, 30 Oct 2007 13:05:02 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <1193735885-8202-10-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1193735885-8202-10-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301305.02640.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, Bryan Wu wrote:
> Current SPI driver enables SPI controller and set the SPI baud register
> for each SPI transfer. But, they should never be changed within a SPI
> message session, in which seveal SPI transfers are pumped.

That's actually not true.  If a driver sets spi_transfer.max_speed_hz
to a nonzero value that's different from the previous bit rate (which
may be spi_device.max_speed_hz), it should be updated before that
transfer segment.  Example, sometimes data can't be clocked out at
the same rate commands can be clocked in.

Similarly with spi_transfer.bits_per_word ... again, it's very possible
that commands and data have different sizes.

Of course, if those values don't change, there'd be no point in
reconfiguring any aspect of those communications parameters...


I'll be forwarding this patch, since this looks like another case
where the main effect of the patch doesn't match its description
and since this patch series has taken too long already.  (Does this
patch even really relate primarily to working with an ST M25P16
flash part??)  Though it'd be reasonable to be more hard-nosed
about this and insist on another go-around for thesse patches.
(Making this the fifth one??)

But I *STRONGLY* suggest someone revisit the issue of whether those
two per-transfer options are now being handled correctly.  As well
as update procedures so that the patch comments start to have a
direct correspondence to what the patches have changed...

- Dave


> This patch 
> move move SPI setting to the begining of a message session. And never
> disables SPI controller until an error occurs.




