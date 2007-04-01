Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbXDASj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbXDASj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbXDASj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:39:57 -0400
Received: from smtpout.mac.com ([17.250.248.171]:59241 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbXDASj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:39:56 -0400
In-Reply-To: <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B118D361-9F40-456F-96B7-E61B16B98432@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 07/16] kconfig-dynamic-frequency.diff
Date: Sun, 1 Apr 2007 14:39:18 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 01, 2007, at 14:15:20, Jan Engelhardt wrote:
>
> Make HZ fully configurable through menuconfig.
>
> Already posted at http://lkml.org/lkml/2006/6/18/111

Instead of that, what about something like this instead:  NOTE: I  
know my mailer mangles diffs and this one was hand-edited based on  
Jan's diff from within my mailer so it probably doesn't apply, but  
it's enough to point out the idea:

diff --fast -Ndpru linux-2.6.17-rc6~/kernel/Kconfig.hz linux-2.6.17- 
rc6+/kernel/Kconfig.hz
--- linux-2.6.17-rc6~/kernel/Kconfig.hz	2006-06-06 02:57:02.000000000  
+0200
+++ linux-2.6.17-rc6+/kernel/Kconfig.hz	2006-06-16 17:15:46.884794000  
+0200
@@ -36,10 +36,17 @@
  	 1000 HZ is the preferred choice for desktop systems and other
  	 systems requiring fast interactive responses to events.

+	config HZ_CUSTOM
+		bool "Custom HZ"
+	help
+	 This allows you to specify your own custom timer frequency, if
+	 the default options are not satisfactory for your use.
+
  endchoice

  config HZ
-	int
+	int if !HZ_CUSTOM
+	int "Customized HZ value" if HZ_CUSTOM
  	default 100 if HZ_100
  	default 250 if HZ_250
  	default 1000 if HZ_1000

