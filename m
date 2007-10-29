Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXJ2Wwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXJ2Wwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXJ2Wwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:52:36 -0400
Received: from gw.goop.org ([64.81.55.164]:50930 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXJ2Wwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:52:36 -0400
Message-ID: <47266431.1010500@goop.org>
Date: Mon, 29 Oct 2007 15:52:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       --cc@redhat.com, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu>
In-Reply-To: <20071029224852.GA27547@elte.hu>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> On Mon, 2007-10-29 at 20:10 -0300, Glauber de Oliveira Costa wrote:
>>     
>>> From: Glauber de Oliveira Costa <glauber@t60.localdomain>
>>>
>>> tsc is very good time source (when it does not have drifts, does not
>>> change it's frequency, i.e. when it works), so it should have its rating
>>> raised to a value greater than, or equal 400.
>>>
>>> Since it's being a tendency among paravirt clocksources to use values
>>> around 400, we should declare tsc as even better: So we use 500.
>>>       
>> Why is the TSC better than a paravirt clocksource?  In our case this 
>> is definitely inaccurate.  Paravirt clocksources should be preferred 
>> to TSC, and both must be made available in hardware for platforms 
>> which do not support paravirt.
>>     
>
> if it's inaccurate why are you exposing it to the guest then? Native 
> only uses the TSC if it's safe and accurate to do so.
>   

It is used as part of the Xen clocksource as a short term extrapolator,
with correction parameters supplied by the hypervisor.  It should never
be used directly.

    J
