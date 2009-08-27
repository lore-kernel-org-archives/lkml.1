Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZH0Mwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZH0Mwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZH0Mwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:52:35 -0400
Received: from rtr.ca ([76.10.145.34]:49232 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZH0Mwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:52:35 -0400
Message-ID: <4A96819D.7060708@rtr.ca>
Date: Thu, 27 Aug 2009 08:52:45 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Mohr <akihana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
In-Reply-To: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Mohr wrote:
> Hi,
> 
> I think I'm having a similar problem to the fellow listed here:
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2007/10/16/344543
> 
> The only difference is that no card will work at all unless it is
> inserted before system power is turned on.  If the card is removed
> while the system is running it stops working and will never return to
> life unless the system is rebooted with the card in the slot.
..

It's probably the b0rked PCIe hotplug support.
The driver is way too strict about things at times,
and as a result it doesn't work "out of the box" on
a huge number of Dell notebooks (and possibly others).

Just create a file called /etc/modprobe.d/pciehp,
and stick this one line into it:

   options pciehp pciehp_force=1

See if that works.

