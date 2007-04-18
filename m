Return-Path: <linux-kernel-owner+w=401wt.eu-S2992874AbXDRRI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992874AbXDRRI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXDRRI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:08:27 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1472 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbXDRRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:08:26 -0400
Message-ID: <46265089.4000409@rtr.ca>
Date: Wed, 18 Apr 2007 13:08:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com>	<20070418140346.636879a1@the-village.bc.nu>	<46262C0E.9000103@rtr.ca> <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca> <46263859.2060309@gmail.com>
In-Reply-To: <46263859.2060309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
> ..
>> It would be nice if somebody who can hear the "pop" would also test this,
>> as it will confirm that this is a complete fix for the problem.
> 
> You'll probably be able to here the "pop" on sleep-to-disk.
> 
>> My "pop" drives are busy elsewhere right now.

The system I do have to test with has a "pop",
but that's from the speakers not the drive.

However, the S.M.A.R.T. data was also shown earlier to provide
a record of the unnecessary wear and tear.

Here it is from two hibernates (Linux "suspend-to-disk") before patching:

-  4 Start_Stop_Count        0x0032   099   099   020    Old_age   Always       -       1711
+  4 Start_Stop_Count        0x0032   099   099   020    Old_age   Always       -       1712
..
- 12 Power_Cycle_Count       0x0032   099   099   020    Old_age   Always       -       1051
+ 12 Power_Cycle_Count       0x0032   099   099   020    Old_age   Always       -       1053
..
-192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       126
-193 Load_Cycle_Count        0x0032   015   015   000    Old_age   Always       -       170404
+192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       128
+193 Load_Cycle_Count        0x0032   015   015   000    Old_age   Always       -       170405

With the patch applied, I don't see *any* new activity in those S.M.A.R.T.
attributes over multiple hibernates (Linux "suspend-to-disk").

Next up, I'll try a few shutdowns and see.

But we should still get Stephen Clark or one of the other reporters
to confirm it on their systems.

-ml

