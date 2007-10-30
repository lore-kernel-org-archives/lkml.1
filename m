Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbXJ3E0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbXJ3E0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXJ3E03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:26:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:35125 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXJ3E02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:26:28 -0400
Message-ID: <4726B218.8010101@qumranet.com>
Date: Tue, 30 Oct 2007 06:24:56 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       jeremy@goop.org, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Glauber de Oliveira Costa <glauber@qumranet.com>, --cc@redhat.com,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [kvm-devel] [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com>	<1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>	<20071029224852.GA27547@elte.hu>	<1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>	<20071029230213.GA1982@elte.hu> <47266B90.8000008@vmware.com>
In-Reply-To: <47266B90.8000008@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> Not really.  In the case hardware TSC is perfect, the paravirt time 
> counter can be implemented directly in terms of hardware TSC; there is 
> no loss in optimization.  This is done transparently.  And virtual TSC 
> can be implemented this way too.
>
> The real improvement that a paravirt clocksource offers over the TSC 
> clocksource is that the guest does not need to measure the TSC frequency 
> itself against some other constant frequency source (which is 
> problematic on a virtual machine).  Instead, the paravirt clocksource 
> queries the hypervisor for the frequency of the counter.  As you know, 
> with clocksource style kernels, it's important to get this frequency 
> correct, or else the guest will have long-term time drift.
>
>   

In addition, a paravirt clocksource can compensate for events like vcpu 
migration to another host cpu.  So I agree: a paravirt clocksource is 
always better than or equal to the tsc.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

