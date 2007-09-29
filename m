Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbXI2Uju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbXI2Uju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXI2Ujm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:39:42 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:36822 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752598AbXI2Ujl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:39:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Y9UbNn2ftiC+bH3BqIV45dQmWxITtOMxzb0zoWcby45zH1FRET4SV239iequ/Pza1Ch+rQ4/08dx1Y8Fi2OVzeSL9XUJQKV8bjauSO+UpCXrabRX+2ccHezS2LcLDtpuJDvXRuTeiNyZFq70ZEkPChgF5AELx5hzUujE+PrrE4E=  ;
X-YMail-OSG: u169IVYVM1k4Wcbb2H_B1QcpM7S6j0NHPW61Bdv1_lbb0wKo
Date: Sat, 29 Sep 2007 13:39:43 -0700
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net, c-d.hailfinger.devel.2006@gmx.net
Subject: Re: [spi-devel-general] IT8716F SPI driver submission?
Cc: linux-kernel@vger.kernel.org
References: <46FE5701.2030000@gmx.net>
In-Reply-To: <46FE5701.2030000@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070929203942.4302D20F0A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The IT8716F accepts commands byte-wise and does all of the lifting on
> the SPI bus as well. There are limitations, though:
> - It can send 1,2,4,5 bytes (including command byte) to the slave and
> read 0,1,2,3 bytes back. Other values are not possible.
> - Bus clock rate is either 33 MHz or 16.5 MHz.
>
> Is there any driver I can start from as reference?

None that I know of.  You might find it's easier to just work with
a bastardized version of the (latest, with the 2.6.24 MTD updates
so it handleds even more chips) m25p80 driver and not go through the
SPI framework.  It doesn't look like you could even bitbang SPI there,
since not all those pins are usable for bit-level I/O.

As you note, that hardware doesn't support all that a SPI controller
does.  It's provided for accessing a single serial flash chip; and
not even to do that very smoothly.  You'd have to somehow prevent that
driver from reading or writing normal size blocks.  And you'd need to
defend against drivers trying to do full duplex or multi-segment I/O
requests, etc.  Lots more work than a bastardized m25p80 driver.  ;)

My limited exposure to SPI on PC hardware -- LPC chips like this, and
newer southbridges -- suggests they tend to be just as, erm, "limited"
as this one in terms of supporting anything other than one particular
variety of serial flash interface.  I think the idea was just to let
board makers use cheaper flash chips when loading the BIOS.  For that,
they don't need the kind of flexible expansion bus SPI is on most SOC
chips; or much throughput.

- Dave

