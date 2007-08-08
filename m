Return-Path: <linux-kernel-owner+w=401wt.eu-S936188AbXHHRFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936188AbXHHRFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXHHREy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:04:54 -0400
Received: from rtr.ca ([64.26.128.89]:2828 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXHHREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:04:52 -0400
Message-ID: <46B9F7B2.6050604@rtr.ca>
Date: Wed, 08 Aug 2007 13:04:50 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca> <46B9CFB3.6020402@gmail.com> <46B9D219.6030509@rtr.ca> <46B9DF91.7050709@rtr.ca> <46B9E2C4.7070307@rtr.ca> <46B9ED48.1010901@gmail.com>
In-Reply-To: <46B9ED48.1010901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> Further to this, if I have an active-writer running at the time of suspend,
>> then even my scripted "sleep 1" is not good enough, as additional writes
>> are still happening before/after the flush.
>>
>> Now I'll reboot and try it with the "sleep 1" hardcoded inside
>> sd_suspend().
> 
> Hmmm... queue quiescing might be broken.  Can you verify there's no
> command issued between STANDBYNOW1 and suspending?

Yeah, I verified that already.  Nothing happens other than
the FLUSH_CACHE_EXT and STANDBY commands.

I've now tried adding various sleeps into the sd_suspend() routine.
The sleeps actually do sleep, but they don't seem to solve the problem there.
The "hdparm -F /dev/sda ; sleep 1" inside my script actually works better,
though even it fails if there's a ton of writes happening.

I put a 4-second sleep in front of the sd_start_stop_device() call,
and here is what I observed:

the disk light flickers briefly,
then the system does absolutely nothing for the 4-seconds,
and then it flickers again,
and then the light comes on solid for a second or two,
and then it suspends.

I am ssssoooooooo confused now.  :)

We need Eric (from Seagate) to enlighten us.

Cheers

