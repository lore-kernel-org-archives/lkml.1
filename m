Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYIDOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYIDOuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYIDOub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:50:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYIDOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:50:31 -0400
Date: Thu, 4 Sep 2008 10:49:56 -0400
From: aris <arozansk@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       dzickus@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       mingo@elte.hu
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904144956.GJ28636@redhat.com>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BFF0C0.7060208@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter -- good question.  The HP systems with this HW will use the hpwdt  
> driver in place of the default nmi watchdog.  When the HW detects a  
> problem, the HW will generate a single NMI that the driver will handle.   
> The driver doesn't want the NMI to be rejected due to a reason code.   
> I'm sure that Thomas Mingarelli, who is cc'd, can provide further 
> details.
it's not the first time this is asked. I think it's needed for some kernel
debuggers as well: make sure a function is called before anything else
when a NMI happens. something that the notifier chain can't do.

> From our quick conversation as well, you raised an interesting point  
> about oprofile, kgdb, and other subsystems that use the NMI notifier  
> chains -- they may be impacted by the NMI callback.
>
> Don (dzickus) or Aris, do you have any thoughts on how to get around the  
> second issue?  We could check to see if anything is registered on the  
> notifier chain and the fail to register the callback.
or call the notifier chain in case it indentifies it's a unexpected NMI?

-- 
Aristeu

