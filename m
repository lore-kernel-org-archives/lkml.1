Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYDIU2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYDIU2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYDIU2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:28:19 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:20529
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757376AbYDIU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:28:17 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 16:28:16 EDT
X-Trace: 55605782/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAFjB/EdTQwss/2dsb2JhbACBXKo+
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Western Digital GreenPower drives and Linux
Date: Wed, 9 Apr 2008 21:18:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092118.35501.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

The subject may be a bit misleading since I haven't investigated the whole 
issue under other OS-es (nor do I plan to), but this is how the story goes..

Those fancy new WD GreenPower drives seem to be heavily suffering from the 
rapidly increasing head load/unload problem. And the bad thing is they don't 
respond to 'hdparm -B', which would mean (I think) their power management 
behaviour is solely up to their firmware.

I got one of them (WD5000AACS) recently and to my horror after less than three 
days of being power on this is what I saw:

9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233

At this rate the disk would reach it's design limit for load/unload cycles in 
around 80 days. Not good - so I implemented a lame workaround of keeping disk 
busy every couple of seconds - hopefully that won't kill it sooner that 
unloads would..

I am also currently talking with first line of WD's tech support trying to get 
some data on how exactly those drives manage head unloading, but that may not 
lead anywhere useful.

So in parallel I decided to ask here to see if someone knows something about 
this?

If it matters, I am running vanilla 2.6.24 on that box and sata_sil is driving 
that disk. Otherwise it is a pretty basic Ubuntu 7.10, a mix of ext3 and jfs 
filesystems, all mounted with noatime. More detailed information available on 
request.

Tvrtko




