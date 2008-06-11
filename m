Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYFKTaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYFKTaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYFKTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:30:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37111 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYFKTaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:30:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <485027AC.6060901@s5r6.in-berlin.de>
Date: Wed, 11 Jun 2008 21:29:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Greg KH <greg@kroah.com>, Chris Clayton <chris2553@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
References: <200806010415.05290.chris2553@googlemail.com>	 <1212950276.3574.7.camel@localhost.localdomain>	 <200806102206.26818.chris2553@googlemail.com>	 <200806111858.05114.chris2553@googlemail.com>	 <20080611191533.GA6189@kroah.com> <1213212282.3461.9.camel@localhost.localdomain>
In-Reply-To: <1213212282.3461.9.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
>> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
>>> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
>>> Jun 11 17:48:18 upstairs last message repeated 236 times
>> This doesn't look good.  It looks like a udev rule in your system is
>> looking for a file that will never show up.  That's a short way to a
>> long delay time :)
>>
>> Try commenting out the rule that does this and see if things are fixed.
> 
> Actually, there's something seriously wrong here:  ioerr_cnt is a
> property of the device, not of the host (as in it will never appear
> under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
> Perhaps an investigation of why udevd-event is looking under host4/ is
> in order.

So the change which commit b0ed43360fdca227048d88a08290365cb681c1a8 
"[SCSI] add scsi_host and scsi_target to scsi_bus" introduced is leading 
the udev scripts onto a wrong trail?

(This commit was the one which Chris found by bisection, see 
http://lkml.org/lkml/2008/6/1/2)
-- 
Stefan Richter
-=====-==--- -==- -=-==
http://arcgraph.de/sr/
