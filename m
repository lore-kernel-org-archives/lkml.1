Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZCTLGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZCTLGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZCTLGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:06:21 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:64052 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315AbZCTLGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:06:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPQVw0lR9Rxo/2dsb2JhbADUCAeDdgY
Date: Fri, 20 Mar 2009 12:06:15 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: New library code
Message-ID: <20090320110615.GC6160@infomag.iguana.be>
References: <20081204155250.59a1d30c@lxorguk.ukuu.org.uk> <20081209161425.GE32662@infomag.infomag.iguana.be> <20081209165440.64501e00@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209165440.64501e00@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I put your new library code in a git branch called alan-generic-watchdog
in the linux-2.6-watchdog-next tree. My old code is in the branch
wim-generic-watchdog. I'm preparing a new tree with the best of both trees
in a new branch called generic-watchdog. I will sent you the merged code
for review in a couple of days.

> > > - Handles the temperature device
> > Why don't we treat the temperature part not as a hwmon?
> 
> Because the temperature interface was there first and is part of the
> existing kernel to user space API. Now that the device is abstracted I
> agree entirely that it should also appear in hwmon and the support
> library code can be extended to do this along with multiple watchdogs.

Agree.

> > > - It does all the reboot, nowayout and module locking and housekeeping
> > Why don't we use the shutdown methods of our platform and other devices instead of the reboot notifier setup?
> 
> As and when watchdogs are all platform devices we probably should. Right
> now most of them are not and we don't really have a proper 'isa_device'
> object yet. I see that as a migration path or an 'aspiration', but having
> it in one place will make that easier to achieve after we have the common
> API.

I'd rather do the conversion to a platform device and the conversion to the
new api in one go. Concerning the isa_device -> see pcwd.c . 

> Likewise sysfs, classes and multiple watchdogs all want addressing but
> that gets a lot easier once everything is using a common framework and a
> passed 'struct watchdog' to make multiple instances just work.

Agree.

Kind regards,
Wim.

