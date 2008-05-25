Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYEYErW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYEYErW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYEYErK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:47:10 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:33505 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYEYErJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:47:09 -0400
Message-ID: <fa686aa40805242147w400e2ff5jf532f8843ec3f85f@mail.gmail.com>
Date: Sat, 24 May 2008 22:47:08 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC] OpenFirmware bindings for the MMC-over-SPI driver
Cc: avorontsov@ru.mvista.com, "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805241256.32639.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	 <200805241256.32639.david-b@pacbell.net>
X-Google-Sender-Auth: fabd9c235702e903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 1:56 PM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 23 May 2008, Anton Vorontsov wrote:
>>
>> This is second attempt to write the OpenFirmware bindings for the
>> MMC-over-SPI (and SPI bindings in general).
>
> Summary:  an OF-specific wrapper around the mmc_spi platform code.
>
> I think a wrapper to encapsulate all the OF-specific knowledge makes
> much sense here.
>
> The only thing that looks odd to me about this is that the wrapper
> is a spi_device rather than an of_device.  To me it makes more sense
> to just have an of_device setting up the right spi_device.  (Though
> maybe I missed some discussion about why that can't work.)

It's not so much that I can't work; more like it's not necessary.
of_platform bus is by no means the prescribed way to work with the
device tree.  In fact, there is talk about moving away from
of_platform bus entirely and using
platform_device/spi_device/i2c_device/etc directly instead since the
of_platform bus is mostly a clone of the platform bus with different
device binding semantics.

As Anton's patch shows, it is straight forward to add a binding that
can extract the platform data out of the device tree without the
overhead of adding an additional of_platform bus device & driver pair.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
