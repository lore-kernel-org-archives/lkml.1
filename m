Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYIDOgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYIDOgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYIDOfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:35:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYIDOfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:35:53 -0400
Message-ID: <48BFF0C0.7060208@redhat.com>
Date: Thu, 04 Sep 2008 10:29:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, arozansk@redhat.com, dzickus@redhat.com,
       Thomas.Mingarelli@hp.com, ak@linux.intel.com, mingo@elte.hu
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins>
In-Reply-To: <1220535463.8609.223.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Why is the DIE_NMIWATCHDOG notifier not sufficient for this driver?
>
>   

Peter -- good question.  The HP systems with this HW will use the hpwdt 
driver in place of the default nmi watchdog.  When the HW detects a 
problem, the HW will generate a single NMI that the driver will handle.  
The driver doesn't want the NMI to be rejected due to a reason code.  
I'm sure that Thomas Mingarelli, who is cc'd, can provide further details.

 From our quick conversation as well, you raised an interesting point 
about oprofile, kgdb, and other subsystems that use the NMI notifier 
chains -- they may be impacted by the NMI callback.

Don (dzickus) or Aris, do you have any thoughts on how to get around the 
second issue?  We could check to see if anything is registered on the 
notifier chain and the fail to register the callback.

P.
