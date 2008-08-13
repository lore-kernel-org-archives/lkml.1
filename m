Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbYHMQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbYHMQPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHMQPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:15:40 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46134 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYHMQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:15:39 -0400
Message-ID: <48A30864.2030106@s5r6.in-berlin.de>
Date: Wed, 13 Aug 2008 18:14:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oneukum@suse.de>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       James.Bottomley@hansenpartnership.com, teheo@novell.com
Subject: Re: Power management for SCSI
References: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 13 Aug 2008, Oliver Neukum wrote:
>> Am Mittwoch 13 August 2008 16:59:23 schrieb Alan Stern:
>> > Is the USB transport unique in its requirement that all the child
>> > devices must be suspended before the link can be powered down?  Maybe
>> 
>> All children that are USB must be powered down. We know in fact that most
>> drives don't care that the device is suspended. The problem was drive
>> enclosures that cut power upon suspension losing cached data.
> 
> You misunderstood my question.  Are there SCSI transports other than
> USB sharing the requirement that all child devices must be suspended
> before the link can be powered down?

Yes in case of FireWire; it's necessary there too (but not sufficient).

(It's a bad example though since I have no good idea whether power
management beyond (a) system suspend and (b) disk spindown is feasible
in reality at all.)

[...]
>> So do we really want to do autosuspend on the device level? Or do we work
>> on hosts and just use the suspend()/resume() support of the sd, sr, ... etc?
> 
> For transports which are like USB, we should do autosuspend at the
> target (not device) level.  This means invoking the suspend/resume 
> routines of the ULDs like sd and sr.  The transport gets notified when 
> all of the targets are suspended.  (Or maybe the host driver gets 
> notified instead; there probably isn't any advantage to using the 
> transport class here.)
> 
> For other transports, we should only do idle-timeout detection.  The
> transport gets notified when any target has been idle for sufficiently 
> long, so that it can power down the link.  The ULDs are not involved.
> 
> Does that sound okay?

Minor correction:  The ULD suspend/resume methods necessarily work on
logical units, not targets.
-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/
