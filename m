Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYKBNz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYKBNz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYKBNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:55:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:27206 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYKBNzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:55:47 -0500
Message-ID: <ac3eb2510811020555r417a3b10xbadc9d87b0c3ea0a@mail.gmail.com>
Date: Sun, 2 Nov 2008 14:55:46 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
Subject: Re: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
In-Reply-To: <20081102121320.GA15349@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225536366.13224.2.camel@nga.site>
	 <20081102121320.GA15349@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 13:13, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> On Sat, Nov 01, 2008 at 11:46:06AM +0100, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
>>
>> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
>
> is this to go in via -pcmcia or via -driver-core?

Would be great if this goes through -pcmcia, and show up in -next
soon, so we can continue to address the rest of the tree in -next,
after the patches are merged from the subsystem trees.

>> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
>> index c68c5d3..5d0e60e 100644
>> --- a/drivers/pcmcia/cs.c
>> +++ b/drivers/pcmcia/cs.c
>> @@ -226,7 +226,7 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
>>       /* set proper values in socket->dev */
>>       dev_set_drvdata(&socket->dev, socket);
>>       socket->dev.class = &pcmcia_socket_class;
>> -     snprintf(socket->dev.bus_id, BUS_ID_SIZE, "pcmcia_socket%u", socket->sock);
>> +     dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);
>
> In other places, you check for !dev_name() afterwards -- why not here?

The name is used in the line just below setting it, which is why we
need to check that it is not NULL. The other case, like in almost all
other cases, the unlikely event of failing to set the name is handled
by a failing call to device_register().

Thanks,
Kay
