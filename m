Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZCAV7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZCAV7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 16:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZCAV64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 16:58:56 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:8855 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZCAV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 16:58:55 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.545
Message-ID: <49AAD3B1.4050501@tremplin-utc.net>
Date: Sun, 01 Mar 2009 19:28:01 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
References: <20090301132953.GF20813@buzzloop.caiaq.de>
In-Reply-To: <20090301132953.GF20813@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> Hi Pavel, Eric,
> 
> are there any plans to free the lis3 driver from its ACPI dependency?
> In fact, this device is I2C/SPI connected which the ACPI layer seems to
> hide from the driver, but to use it on embedded devices, the bus drivers
> must be used directly and the dependeny seems entirely unnecessary
> anyway.
> 
> Also I got the feeling that using a globally exported 'adev' symbol all
> over the different layers is not the best practice - I suspect all the
> occasions could be solved with private pointers and/or container_of().
> Isn't there any cleanup pending?
Hi Daniel,
Actually, the hp_accel.c file is dedicated to the acpi part. The
lis3lv02d.c file is supposed to be bus agnostic. In practice I agree
it's not completely true, but this is mainly because for now there is
only one bus supported (ACPI) and therefore the work for making it
completely bus-independent is not yet worthy. As soon as someone is
interested in writing a I²C/SPI interface it will become much more
apparent what has to be generalized.

Indeed, as you noticed, the main work left to do is to generalize
acpi_lis3lv02d (adev) to something ACPI independent. I'd say this could
be done simply by changing the signature of the four callback functions
and having device being just a void*.

If you are willing to write one of the I²C/SPI interfaces, I'll be happy
to support you.

See you,
Eric

