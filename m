Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXKTO32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXKTO32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXKTO3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:29:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:25419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXKTO3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:29:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,441,1188802800"; 
   d="scan'208";a="394882855"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected on CPU#0!"
Date: Tue, 20 Nov 2007 06:29:27 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE251B16@orsmsx423.amr.corp.intel.com>
In-Reply-To: <4742980A.60407@t-online.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected on CPU#0!"
Thread-Index: AcgrTcsP/B88KAWZQ2mPnADACNcmNwAM3O3Q
References: <474227F9.8050909@t-online.de> <924EFEDD5F540B4284297C4DC59F3DEE251A40@orsmsx423.amr.corp.intel.com> <4742980A.60407@t-online.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>, <mingo@elte.hu>
X-OriginalArrivalTime: 20 Nov 2007 14:29:19.0013 (UTC) FILETIME=[BC4F0550:01C82B81]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Harald Dunkel [mailto:harald.dunkel@t-online.de] 
>Sent: Tuesday, November 20, 2007 12:17 AM
>To: Pallipadi, Venkatesh
>Cc: Linux Kernel list
>Subject: Re: 2.6.23.8, ondemand scaling governor: "BUG: soft 
>lockup detected on CPU#0!"
>
>Pallipadi, Venkatesh wrote:
>> 
>> Can you try switching to powersave governor (which should 
>always run CPU
>> at 400MHz) and see whether you see similar error?
>> 
>
>Yes, if I move from performance to powersave, then I see a similar
>error:
>
>Nov 20 09:06:48 bugs kernel: BUG: soft lockup detected on CPU#0!
>Nov 20 09:06:48 bugs kernel:  [<c013cf8d>] softlockup_tick+0x91/0xa6
>Nov 20 09:06:48 bugs kernel:  [<c012269c>] 
>update_process_times+0x3a/0x5d
>Nov 20 09:06:48 bugs kernel:  [<c0131219>] tick_sched_timer+0x115/0x164
>Nov 20 09:06:48 bugs kernel:  [<c012d311>] 
>hrtimer_interrupt+0x102/0x191
>Nov 20 09:06:48 bugs kernel:  [<c0106cd6>] timer_interrupt+0x2e/0x34
>Nov 20 09:06:48 bugs kernel:  [<c013d1f6>] handle_IRQ_event+0x1a/0x3f
>Nov 20 09:06:48 bugs kernel:  [<c013e4e1>] handle_level_irq+0xa8/0xb7
>Nov 20 09:06:48 bugs kernel:  [<c0106367>] do_IRQ+0x53/0x6c
>Nov 20 09:06:48 bugs kernel:  [<c0104853>] common_interrupt+0x23/0x28
>Nov 20 09:06:48 bugs kernel:  =======================
>
>

This looks like TSC related issue. Ingo's patch commit id
a3b13c23f186ecb57204580cc1f2dbe9c284953a
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.g
it;a=commit;h=a3b13c23f186ecb57204580cc1f2dbe9c284953a 
should help.

Thanks,
Venki
