Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZCBA4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZCBA4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZCBA4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:56:03 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45541 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCBA4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:56:01 -0500
Date: Mon, 2 Mar 2009 01:55:54 +0100
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
Message-ID: <20090302005554.GB3223@buzzloop.caiaq.de>
References: <20090301132953.GF20813@buzzloop.caiaq.de> <49AAD3B1.4050501@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AAD3B1.4050501@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 07:28:01PM +0100, Éric Piel wrote:
> > are there any plans to free the lis3 driver from its ACPI dependency?
> > In fact, this device is I2C/SPI connected which the ACPI layer seems to
> > hide from the driver, but to use it on embedded devices, the bus drivers
> > must be used directly and the dependeny seems entirely unnecessary
> > anyway.
> > 
> > Also I got the feeling that using a globally exported 'adev' symbol all
> > over the different layers is not the best practice - I suspect all the
> > occasions could be solved with private pointers and/or container_of().
> > Isn't there any cleanup pending?
> Hi Daniel,
> Actually, the hp_accel.c file is dedicated to the acpi part. The
> lis3lv02d.c file is supposed to be bus agnostic. In practice I agree
> it's not completely true, but this is mainly because for now there is
> only one bus supported (ACPI) and therefore the work for making it
> completely bus-independent is not yet worthy. As soon as someone is
> interested in writing a I²C/SPI interface it will become much more
> apparent what has to be generalized.

Well, it's clear already - there must be no occurance of apci specific
structs and calls in lis3lv02d.c and all the calls to the bus type need
to go thru a generic interface which is - as you say - bus independent.

> Indeed, as you noticed, the main work left to do is to generalize
> acpi_lis3lv02d (adev) to something ACPI independent. I'd say this could
> be done simply by changing the signature of the four callback functions
> and having device being just a void*.
> 
> If you are willing to write one of the I²C/SPI interfaces, I'll be happy
> to support you.

Ok, I'll start and seperate things then but will need you help with
testing as I don't have the hardware the driver was written for
originally. I do have, in turn, a custom board with this chip connected
via SPI.

Is there any patch pending on top of Linus' current git head that I
should base my patches on?

Thanks,
Daniel
