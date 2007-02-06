Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXBFVy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXBFVy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965557AbXBFVyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:54:54 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43401 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965545AbXBFVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:54:53 -0500
Message-ID: <45C8F92C.9050605@vmware.com>
Date: Tue, 06 Feb 2007 13:54:52 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 8/11] Add a CPU KHZ calibration function to paravirt-ops
References: <200702060353.l163rNP7000763@zach-dev.vmware.com> <20070206122628.GB47229@muc.de>
In-Reply-To: <20070206122628.GB47229@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Feb 05, 2007 at 07:53:23PM -0800, Zachary Amsden wrote:
>   
>> Provide a paravirtualized way to get the CPU clock frequency; this allows much
>> of the code in tsc.c to be shared between all paravirt implementations.
>>     
>
> Is this really needed? 
>   

Honestly, no.  But it is better and more accurate to do it.

> What worries me somewhat of your patches is that you seem
> to be quick at adding new hooks. But I would like to keep
> paravirtops as minimal as possible with new hooks only
> added when there is a very good justification.
>
> I don't see it here.
>   

We can calibrate CPU frequency pretty accurately, despite being in a VM 
where time does not operate in the normal way.  Many other hypervisors 
won't be able to do such a good job, or might not implement the required 
hardware.

Adding this hook allows everyone to just re-use all the frequency 
scaling / recalibration code in tsc.c.

The primary justification is allowing code re-use, which is why I 
allowed myself to add a hook.  I also want paravirt-ops to be as minimal 
as possible.

Zach
