Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXA1JFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXA1JFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 04:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXA1JFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 04:05:17 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20353 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbXA1JFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 04:05:10 -0500
Message-ID: <45BC6740.1000606@tls.msk.ru>
Date: Sun, 28 Jan 2007 12:05:04 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
References: <593246.19408.qm@web52505.mail.yahoo.com> <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 27 2007 10:31, Marc Perkel wrote:
[]
>> Sorry about that. I'm using Fedora Core 6. /dev/md0
>> and /dev/md1, buth of which are raid 1 arrays survive
>> the reboot. But when I make a raid 0 out of those two
>> raid arrays that's what is vanishing.
> 
> That's interesting. I am using Aurora Corona, and all but md0 vanishes.
> (Reason for that is that udev does not create the nodes md1-md31 on
> boot, so mdadm cannot assemble the arrays.)

This is nonsense.

Mdadm creates those nodes automa[tg]ically - man mdadm, search for --auto.
Udev has exactly nothing to do with mdX nodes.

In order for an md array to be started up on boot, it has to be specified
in /etc/mdadm.conf.  With proper DEVICE line in there.  That's all.

If you're using raid0 on top of two raid1s (as opposed to using raid10
directly - which is more efficient and flexible), the DEVICE line in
mdadm.conf should be either `partitions' (usually preferred way), or -
in case direct device list is specified - should contain both real
disks AND the raid1 arrays.

But in any case, this has exactly nothing to do with kernel.
It's 100% userspace issues, I'd say distribution-specific issues.

/mjt
