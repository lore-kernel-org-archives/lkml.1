Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbYCDTK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbYCDTK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762389AbYCDTKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:10:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:32610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760821AbYCDTKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:10:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="349763819"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Tue, 4 Mar 2008 11:01:28 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080304181924.70aaf8c1@mjolnir.drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Thread-Index: Ach+HFKjuHqiSddHQzmZuRVVvOnQFwADVtIQ
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com><Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org><20080303231033.GB15255@one.firstfloor.org><20080304040048.GA31562@codemonkey.org.uk><20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: "Dave Jones" <davej@codemonkey.org.uk>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "LKML" <linux-kernel@vger.kernel.org>, "Adam Belay" <abelay@novell.com>,
       "Lee Revell" <rlrevell@joe-job.com>,
       <linux-pm@lists.linux-foundation.org>, "Pavel Machek" <pavel@ucw.cz>
X-OriginalArrivalTime: 04 Mar 2008 19:00:14.0380 (UTC) FILETIME=[FAA2EEC0:01C87E29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-list@drzeus.cx] 
>Sent: Tuesday, March 04, 2008 9:19 AM
>To: Pallipadi, Venkatesh
>Cc: Dave Jones; Andi Kleen; Alan Stern; LKML; Adam Belay; Lee 
>Revell; linux-pm@lists.linux-foundation.org; Pavel Machek
>Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
>
>On Tue, 4 Mar 2008 07:14:23 +0100
>Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>
>> 
>> Many devices today are of a less than stellar quality, and singing
>> capacitors are a common problem. A high-pitch noise is 
>created, caused
>> by power fluctuations as the processor enters and leaves 
>deep sleep at
>> a high frequency.
>> 
>> Instead of just disabling the deep sleep (which wastes power), this
>> patch allows you to reduces the number of times it is entered so that
>> the frequency can be kept inaudible.
>> 
>> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>> --
>
>Hold off on this. It turns out it still has major problems. 
>The menu algorithm now and then gets really bad at predicting 
>sleep times, completely killing this avoidance scheme.
>
>(On that subject, does anyone except Adam understand that 
>algorithm? Some comments wouldn't hurt...)

Prediction is based on cumulative time till "non expected wakeup". So,
prediction will come into play only when there are very short wakeups
due to "unexpected wakeups".

>So for now, I'm back to thinking that measuring the interval 
>between deep sleeps is the better approach. I could use some 
>ideas for a good clock source though. I haven't dug much 
>deeper than jiffies when it comes to kernel timekeeping.

I think best solution is to use get_last_residency that is already
there. If the last residency or expected_us is very low, you can avoid
deep idle states. That way you don't have to depend on jiffies being
updated at the time you are checking it.

Thanks,
Venki
