Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXEFNvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXEFNvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 09:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXEFNvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 09:51:11 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:48696
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXEFNvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 09:51:10 -0400
Message-ID: <463DEAF8.1040607@microgate.com>
Date: Sun, 06 May 2007 08:49:28 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oliver Neukum <oliver@neukum.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	<1178381287.3379.8.camel@x2>	<20070505173647.544f6707@the-village.bc.nu>	<200705052007.16742.oliver@neukum.org> <20070505225241.54a5d01d@the-village.bc.nu>
In-Reply-To: <20070505225241.54a5d01d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 5 May 2007 20:07:15 +0200
> Oliver Neukum <oliver@neukum.org> wrote:
>> should I understand this so that, if tty_buffer_request_room() returns
>> less than requested, the rest of the data should be dropped on the
>> floor?
> 
> If it returns NULL then either there is > 64K buffered (we can adjust
> that if anyone shows need - its just for sanity) or the system is out of
> RAM. 


It sounds bad, but I think dropping the data make sense with the
new tty buffering code.

My interpretation of the tty buffering is that
it is intended to be the main receive buffer facility
for the driver.

It simplifies and centralizes these functions so
the driver does not need implement policies such as when to
flush for user request, expand under load, crop when too large.

It should not be the driver's responsibility to
try and work around the tty buffering if it becomes full.
That adds other complexity such as when the driver should
attempt to push the data again: when more data is received?
after a timeout?

If the tty buffering runs dry, then maybe put out an error message.
If the losses occur too often then the tty buffering code needs to
be adjusted.

--
Paul


