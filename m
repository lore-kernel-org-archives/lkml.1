Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXCHTym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXCHTym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXCHTym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:54:42 -0500
Received: from mtaout4.012.net.il ([84.95.2.10]:60993 "EHLO mtaout4.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXCHTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:54:41 -0500
Date: Thu, 08 Mar 2007 21:44:38 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [patch] disable NMI watchdog by default
In-reply-to: <45EC3F25.5060308@tmr.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Message-id: <45F067A6.8090707@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 08 Mar 2007 21:44:38 +0200 (IST)
References: <20070114092926.GA14465@elte.hu> <45EC3F25.5060308@tmr.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
>>
>> there's a new NMI watchdog related problem: KVM crashes on certain 
>> bzImages because ... we enable the NMI watchdog by default (even if 
>> the user does not ask for it) , and no other OS on this planet does 
>> that so KVM doesnt have emulation for that yet. So KVM injects a #GP, 
>> which crashes the Linux guest:
>>
> I'm missing something, what limits this to systems running under kvm?
>

Most likely kvm doesn't implement the msrs which drive the nmi 
watchdog.  That makes it a kvm bug, not a problem with the nmi 
watchdog.  Emulating it correctly is fairly difficult, though, 
especially if we want to migrate virtual machines between different 
processor models, so I hope this goes in.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

