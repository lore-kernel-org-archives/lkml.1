Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXD0IoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXD0IoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXD0IoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:44:17 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:4390 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbXD0IoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:44:16 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Best CONFIG_HZ value for scheduler testing?
Date: Fri, 27 Apr 2007 10:44:13 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271044.13916.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Con and Ingo!

What would be the best CONFIG_HZ value for scheduler testing? I used 
1000HZ for a long time, but use 300HZ since 2.6.20. This worked well 
enough for sd-0.46 and previous versions and ck patches...

martin@deepdance:Computer/Deepdance/Kernel> grep "CONFIG_HZ=" */config*
2.6.13/config-2.6.13.3-tp23--2005-10-07:CONFIG_HZ=1000
2.6.13/config-2.6.13.4-tp23--2005-10-13:CONFIG_HZ=1000
2.6.13/config-2.6.13-tp23--2005-09-03:CONFIG_HZ=1000
2.6.13/config-2.6.13-tp23-ibmacpi-0.12--2005-09-06:CONFIG_HZ=1000
2.6.14/config-2.6.14.2-tp23--2005-11-13:CONFIG_HZ=1000
2.6.14/config-2.6.14.3-tp23-sws2-2.2-rc14--2005-12-08:CONFIG_HZ=1000
2.6.14/config-2.6.14.4-tp23-sws2-2.2-rc14--2005-12-23:CONFIG_HZ=1000
2.6.14/config-2.6.14.5-tp23-sws2-2.2-rc15--2005-12-30:CONFIG_HZ=1000
2.6.15/config-2.6.15.1-tp23-sws2-2.2-rc16--2006-01-17:CONFIG_HZ=1000
2.6.15/config-2.6.15.2-tp23-sws2-2.2--2006-02-01:CONFIG_HZ=1000
2.6.15/config-2.6.15.4-tp23-sws2-2.2--2006-02-16:CONFIG_HZ=1000
2.6.15/config-2.6.15.6-tp23-sws2-2.2--2006-03-18:CONFIG_HZ=1000
2.6.15/config-2.6.15.7-tp23-sws2-2.2--2006-04-14:CONFIG_HZ=1000
2.6.15/config-2.6.15.7-tp23-sws2-2.2_2--2006-05-31:CONFIG_HZ=1000
2.6.16/config-2.6.16.11-tp23-sws2-2.2.5--2006-04-28:CONFIG_HZ=1000
2.6.16/config-2.6.16.4-tp23-sws2-2.2.4--2006-04-12:CONFIG_HZ=1000
2.6.17/config-2.6.17.11-ck1-tp23-sws2-2.2.7:CONFIG_HZ=1000
2.6.17/config-2.6.17.1-tp23--2006-06-23:CONFIG_HZ=1000
2.6.17/config-2.6.17.1-tp23-sws2-2.2.6-xfs-fix--2006-06-28:CONFIG_HZ=1000
2.6.17/config-2.6.17.1-tp23-sws-2.2.5.3--2006-06-23:CONFIG_HZ=1000
2.6.17/config-2.6.17.7-tp23-sws2-2.2.7:CONFIG_HZ=1000
2.6.18/config-2.6.18-ck1-tp23-sws-2.2.8--2006-10-01:CONFIG_HZ=1000
2.6.19/config-2.6.19.1-ck2-tp23-sws2-2.2.9:CONFIG_HZ=1000
2.6.19/config-2.6.19.2-ck2-tp23-sws2-2.2.9.3:CONFIG_HZ=1000
2.6.20/config-2.6.20.1-ck1-tp23-sws2-2.2.9.7:CONFIG_HZ=300
2.6.20/config-2.6.20.3-ck1-tp23-sws2-2.2.9.9:CONFIG_HZ=300
2.6.20/config-2.6.20.4-ck1-tp23-rsdl-0.33-sws2-2.2.9.10:CONFIG_HZ=300
2.6.20/config-2.6.20.7-tp23-sws2-2.2.9.9-cfs-v5:CONFIG_HZ=300
2.6.20/config-2.6.20.7-tp23-sws2-2.2.9.9-cfs-v6-rc7:CONFIG_HZ=300
2.6.20/config-2.6.20.7-tp23-sws2-2.2.9.9-sd-0.46:CONFIG_HZ=300
2.6.20/config-2.6.20.7-tp23-sws2-2.2.9-sd-0.4.4:CONFIG_HZ=300

Any recommendation? I thought 300HZ was nice two to its compatibility with 
PAL and NTSC refresh rates, but then I have notebooks with LCD displays 
and do not use any TV cards whatsoever and it might be totally irrelevant 
to me.

Well 2.6.21 is out so I may switch to DYNTICKS soon anyway...

About scheduler test results on my two ThinkPads... These are just two 
ThinkPads - so my results are not that representative . By contacting the 
people on the linux-thinkpad mailinglist it might be possible to get 
broader test results[1]. I would be providing my precompiled kernels as 
Debian packages if you desired - they should work with Debian Etch, but 
they use libata PATA drivers.

[1] http://mailman.linux-thinkpad.org/mailman/listinfo/linux-thinkpad

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
