Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbYD0PsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbYD0PsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYD0Pr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:47:58 -0400
Received: from web36701.mail.mud.yahoo.com ([209.191.85.35]:32249 "HELO
	web36701.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753559AbYD0Pr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:47:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Lub++7Z2SPco9Dq2DJvliYCPq2tlEcopeMmspL5QuxyMdvm/sikF6M9utAhAy+AyQeZ+PCrhWTBJNqH+H15758LGtpH4IHRVCNl6Pq7VUifW6+eeEmKuyJhyArWpmvLjX0mq6n4O3LjfRLWUHvSmuF7pjjoDeJcVPJhVKge/71U=;
X-YMail-OSG: mn4Y6YMVM1nsbJ.vFTHFaGWgRbWZCh8.gdyiwRLQQF9St6meovLXTvQL3wxZUVeJD7ByqIQYQUYrZgcwYyj4xCv9V0aUlXkT87QCV9uCRjABgYnhDsUEwoTmTg--
Date: Sun, 27 Apr 2008 08:47:56 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
To: Kim Hansen <kimhanse@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c878e2290804270359w4fe4392flc41a5fb074152572@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <622387.91709.qm@web36701.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kim Hansen <kimhanse@gmail.com> wrote:

> I have the problem that the SD card slot does not work on my Toshiba
> Protege M400 with my current kernel (2.6.24), it worked for me with
> 2.6.18 but has been broken at least since 2.6.22.
> 
> The problem is that nothing happens, dmesg is silent and I guess the
> cause is that the driver does not see the hardware.
> 
> How should I start debugging this?
> 

First, there's an option in the kernel config enabling debugging print-outs
(called "MMC Debugging" under MMC). Enable it, recompile the modules and you'll
get plenty of dmesg noise.

Second, the fact modules are loaded means that driver sees the hardware all
right. There can be some sort of interplay between sdhci and tifm_sd as they
use the same chip. I think you should blacklist one of them. Which one -
depends on the settings in you flashmedia chip's eeprom (some vendors disable
sdhci interface and some flashmedia one).

You need an mmc_block module loaded too.

In the worst case, you can always blame the TI. Some TI guy notified me that my
driver contains errors affecting 803b series controllers (I myself have a
8033). He, however, had not told me what they are. Very nice, indeed.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
