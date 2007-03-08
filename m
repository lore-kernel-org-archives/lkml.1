Return-Path: <linux-kernel-owner+w=401wt.eu-S1030817AbXCHWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817AbXCHWb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXCHWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:31:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52790 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030817AbXCHWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:31:58 -0500
Message-ID: <45F08EDC.30003@vmware.com>
Date: Thu, 08 Mar 2007 14:31:56 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
References: <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com>	 <1173302503.24738.795.camel@localhost.localdomain>	 <45EF372E.7030600@goop.org>	 <1173308717.24738.898.camel@localhost.localdomain>	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>	 <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org>
In-Reply-To: <45F07D07.5090003@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> We faithfully emulate lapic, io_apic, the pit, pic, and a normal
>> interrupt subsystem.
>>     
>
> Can you not just use the apic clock driver directly then?  Do you need
> to do anything special?
>   

The apic clock driver is going to program the apic, not our virtual 
clock, which tracks real time, available and stolen time.  APIC has no 
idea about any of this.

We want an APIC, just purely as a local interrupt controller, and a 
separate, paravirt timer device.  It is not very complicated.

The problem is that we are not supposed to fiddle with APIC internals, 
so we shouldn't be using their clock events, so we can't use their low 
level local timer interrupt, and we are not supposed to write our own.  
So we need a weird hack somewhere because we are not allowed to use any 
of the paths that currently work for our code, because of the 
maintenance burden it imposes by misusing the interfaces.

The larger problem I am having is that nobody wants to give productive 
feedback on how to fix the problem, just sit around and fling muck.

Zach
