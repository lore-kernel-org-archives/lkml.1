Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYBGORV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYBGORV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYBGORH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:17:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60531 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754901AbYBGORG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:17:06 -0500
Date: Thu, 7 Feb 2008 15:17:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, john.ronciak@intel.com,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       auke-jan.h.kok@intel.com
Subject: e1000 1sec latency problem
Message-ID: <20080207141718.GA2030@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have the famous e1000 latency problems:

64 bytes from 195.113.31.123: icmp_seq=68 ttl=56 time=351.9 ms
64 bytes from 195.113.31.123: icmp_seq=69 ttl=56 time=209.2 ms
64 bytes from 195.113.31.123: icmp_seq=70 ttl=56 time=1004.1 ms
64 bytes from 195.113.31.123: icmp_seq=71 ttl=56 time=308.9 ms
64 bytes from 195.113.31.123: icmp_seq=72 ttl=56 time=305.4 ms
64 bytes from 195.113.31.123: icmp_seq=73 ttl=56 time=9.8 ms
64 bytes from 195.113.31.123: icmp_seq=74 ttl=56 time=3.7 ms

...and they are still there in 2.6.25-git0. I had ethernet EEPROM
checksum problems, which I fixed by the update, but problems are not
gone.

irqpoll helps.

nosmp (which implies XT-PIC is being used) does not help.

 16:       1925          0   IO-APIC-fasteoi   ahci, yenta, uhci_hcd:usb2, eth0

Booting kernel with nosmp/ no yenta, no usb does not help.

Hmm, as expected, interrupt load on ahci (find /) makes latencies go
away.

It should be easily reproducible on x60 with latest bios, it is 100%
reproducible for me...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
