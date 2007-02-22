Return-Path: <linux-kernel-owner+w=401wt.eu-S1945894AbXBVDpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945894AbXBVDpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945906AbXBVDpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:45:19 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:31873 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945894AbXBVDpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:45:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=hCscIsMB2ukZenu+PPUM1W7YzuRficTYLLPgLKrNbz28Dn5OEj00NXFYQbXLerLyQVBjNCF7cmtaYVEorACBJcE6Zqv/b3IGefS/OlP9rKs/ABKmfQNEmaCVyx8yl7Vt+ij/yd4t7RoMuLX4Hm5LKrvJhmACW4E+7e/NMYn3bNM=  ;
X-YMail-OSG: wgV6A_EVM1kwtF02VgV8sTOGlW_k9YvHBR6S1llMe11EtImljxqD1l5DpgO8_K2N9OhXXY5ZzkfYevG7FG_fBk70YOtNNiinHWU79acwticuM7sN6ciMRA--
From: David Brownell <david-b@pacbell.net>
To: rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
Subject: [patch/rfc 0/6] rtc framework: remove class_device, use class suspend()/resume()
Date: Wed, 21 Feb 2007 19:45:14 -0800
User-Agent: KMail/1.7.1
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702211945.15003.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following this message (on the RTC list) are six patches:

 - Remove the /sys/class/rtc-dev class_device, and a class_interface
 - Use "struct rtc_device" in the external interface, not class_device
 - Simplify the sysfs attribute handling, removing a class_interface
 - Simplify the /proc/driver/rtc handling, removing the last class_interface
 - Remove the class_device in "struct rtc_device"; now suspend()/resume() work
 - Implement class suspend()/resume() so the system clock is updated on resume

The main point of this series of patches is that last one, which I'll
circulate just a bit more widely.  (Although I think the first four are
also nice cleanups!)   It might be the first example of a framework that
uses the "new" class level suspend()/resume() calls to offload drivers.

Other than actually using that new PM infrastructure, this series should
be interesting since it addresses one of the few remaining obstacles to
having the "Generic Time-Of-Day" (GTOD) framework be fully generic, in
the sense of working with whatever RTC is available on the platform (which
includes ones accessed through I2C or SPI, so that spinlocked access is
insufficient) and removing arch-specific RTC hooks.

This has been lightly tested on one of the ARMs that doesn't yet have
new-style dynamic tick working.  I'm sure fault paths need tweaking yet.

- Dave

