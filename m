Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXJXWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXJXWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXJXWhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:37:15 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38234 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754298AbXJXWhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:37:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P+2j0X7yGIHvOrK/uEtEBJUY83CWQbKrCA9OeeCoVj6Y4d5Robo9dFHfUab+Ei8oG2odo/6yQ10eqAnR87umQF8REKmN1LuD2L330UK0UX5TDL08drdN6mmQ9O2572RJtN2TmlF/pJz4TCxwuqRtaLYoIMWBDzFVtGxbB+jBWPQ=  ;
X-YMail-OSG: TLpUumsVM1n.tESbd7z6kS_DUhd64y9.VO3o0CM5nr9_BLft
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: mmc_spi stopped working
Date: Wed, 24 Oct 2007 15:37:10 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20071017211923.31fde15e@poseidon.drzeus.cx> <20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071022200335.7c1eca12@poseidon.drzeus.cx>
In-Reply-To: <20071022200335.7c1eca12@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241537.10566.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Pierre Ossman wrote:
> On Wed, 17 Oct 2007 12:37:13 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > When enumerating MMC cards using SPI, don't support the "just probe"
> > mechanism since it doesn't always work.  Instead, always wait for the
> > reset to complete before issuing the next request.
> > 
> > This is a regression ... this SanDisk MMC card used to enumerate with
> > no trouble, despite this particular spec violation.
> > 
> 
> I've been testing a bit more here, and I can't get this particular bug.

It's not just a bug, it's a regression ... a new bug which
was introduced by some patch.  ;)


> I have others though: 
> 
> Out of my five MMC cards, only two work properly. One doesn't respond
> to SPI commands at all, and two hang on a second CMD0 and return
> ILLEGAL_COMMAND on a second run of CMD1. All of this is of course wildly
> out of spec. SPI seems to be a bonus, not a given. :/   

SPI works fine on all the MMC and SD cards I've got here,
other than the minor glitch fixed by the "don't just probe"
patch I sent.

As you know, to be spec-conformant they *must* support SPI.
Agreed, there are too many vendors who don't appear to value
following specs.  If those cards which are using the MMC or
SD trade marks, you might notify the relevant consortium and
asking them to fix those vendors.  ;)


> As for your card, could you send me a dump as I'm unable to produce
> the issue here? 

I'm not sure what you mean by "dump", but appended the sysfs attributes
produced after I disabled that new "just probe" mechanism.

- Dave



This is a dump of the /sys/class/mmc_host/mmc0/mmc0:0001 file attributes
(except the card serial number) for a SanDisk MMC card which doesn't like
SPI requests (like reading OCR) before the reset finishes.

This card _used_ to enumerate with the MMC-over-SPI stack, but
a recent change in the MMC core now prevents it from doing that...

=== cid
00000000  30 30 30 30 30 32 35 33  34 34 34 64 34 32 32 64  |00000253444d422d|
00000010  33 31 33 36 33 32 61 39  31 66 31 30 38 34 33 31  |313632a91f108431|
00000020  0a                                                |.|
00000021

=== csd
00000000  34 34 32 36 30 30 32 61  31 66 66 39 38 33 64 33  |4426002a1ff983d3|
00000010  65 34 62 34 38 33 66 66  31 32 34 30 34 30 38 31  |e4b483ff12404081|
00000020  0a                                                |.|
00000021

=== date
00000000  30 38 2f 32 30 30 31 0a                           |08/2001.|
00000008

=== fwrev
00000000  30 78 32 0a                                       |0x2.|
00000004

=== hwrev
00000000  30 78 33 0a                                       |0x3.|
00000004

=== manfid
00000000  30 78 30 30 30 30 30 32  0a                       |0x000002.|
00000009

=== name
00000000  53 44 4d 42 2d 31 36 0a                           |SDMB-16.|
00000008

=== oemid
00000000  30 78 30 30 30 30 0a                              |0x0000.|
00000007

=== type
00000000  4d 4d 43 0a                                       |MMC.|
00000004

