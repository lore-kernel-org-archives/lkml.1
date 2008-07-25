Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYGYBRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYGYBRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYGYBRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:17:08 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:36547 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752818AbYGYBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:17:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GwLpP0rK5oql5KugTp/lmkSv/isl1HsofThLcDOuHFU8Fho63O2ll7sZizwKUQLA3p7oSmKfWEiUGZmHxD8G9j+NNZ669QzZx1YQwnCG0fPJzQi6DlBx6erHlw2fH1zn/ea6yRbkjMCGoXB6HKLqFTW18ld5rWn7HtFrLYY1uwE=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [patch 2.6.26] gpio: pcf857x handle pca9500 and pca9501
Date: Thu, 24 Jul 2008 18:17:04 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <4888A8E5.6050700@gmail.com>
In-Reply-To: <4888A8E5.6050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241817.04624.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Jonathan Cameron wrote:
> These two chips have two elements (on different i2c addresses),
> the first is a clone of the pcf8574 and the second 2kBit eeprom.

That is, NXP documents say it's a pcf8582 eeprom, which
is software-compatible with what Linux calls a 24c02 chip.

It'd be worth sending a patch so drivers/i2c/chips/at24.c
can handle those EEPROMs ...


> Seems easiest to support these separately so main query about
> this patch is should the device naming reflect this dual 
> functionality. 
> 
> I've been using the pcf857x driver with a 9500 for several
> months without problems and just want this in to clean up
> a confusing element in a board config. 

Hmm, well I don't really see a way around having two entries
in the relevant boards' i2c board info ... so this patch just
ensures that *one* entry can list the actual part.

I'm curious why you added this chp to the pcf857x driver
rather than to the at24 driver ... since it's quite obvious
from docs that the chip is pcf8574-compatible, but only the
pca9500 lists the EEPROM compatibility.

I guess given my druthers I'd update Kconfig for both drivers
to mention these parts (and their need for two drivers), plus
add them to the at24 driver (rather than pcf857x) purely because
the docs are, overall, more clear about the GPIO compatibility
than about the EEPROM.

- Dave

 
> As the Kconfig title for these is getting a bit long and the
> datasheet for these starts with stating they are pcf957x
> compatible so I haven't changed it. 

Right; helptext can have a sentence.
