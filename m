Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXEaOes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXEaOes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXEaOel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:34:41 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24002 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXEaOel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:34:41 -0400
Date: Thu, 31 May 2007 08:34:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86
 irq handling
In-reply-to: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Zwane Mwaikambo <zwane@linuxpower.ca>
Message-id: <465EDCF4.7010700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I just realized that except for doing the code review and noticing
> that the current cpu hotplug code is fundamentally incompatible
> with x86 I haven't done anything about it.  So here is my patch
> to document what is wrong.
> 
> The current cpu hotplug code requires irqs to be migrated from a cpu
> outside of irq context.  On x86 ioapics simply do not support this,
> making the code unfixable without major redesign of the generic cpu
> hotplug code.
> 
> So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
> and adds a WARN_ON so people that do enable it are not in doubt about
> which part of the code is broken, even if it does work for them.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

I don't think this is useful, though the code may be problematic, this 
patch will break suspend on all SMP machines with an existing config, 
which is a major regression..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

