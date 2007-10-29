Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbXJ2Wpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbXJ2Wpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbXJ2WpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:45:15 -0400
Received: from gw.goop.org ([64.81.55.164]:60496 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbXJ2WpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:45:13 -0400
Message-ID: <47266276.4030000@goop.org>
Date: Mon, 29 Oct 2007 15:45:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       --cc@redhat.com, mingo@elte.hu, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Mon, 2007-10-29 at 20:10 -0300, Glauber de Oliveira Costa wrote:
>   
>> From: Glauber de Oliveira Costa <glauber@t60.localdomain>
>>
>> tsc is very good time source (when it does not have drifts, does not
>> change it's frequency, i.e. when it works), so it should have its rating
>> raised to a value greater than, or equal 400.
>>
>> Since it's being a tendency among paravirt clocksources to use values
>> around 400, we should declare tsc as even better: So we use 500.
>>     
>
> Why is the TSC better than a paravirt clocksource?  In our case this is
> definitely inaccurate.  Paravirt clocksources should be preferred to
> TSC, and both must be made available in hardware for platforms which do
> not support paravirt.
>
> Also, please cc all the paravirt developers on things related to
> paravirt, especially things with such broad effect.  I think 400 is a
> good value for a perfect native clocksource.  >400 should be reserved
> for super-real (i.e. paravirt) sources that should always be chosen over
> a hardware realistic implementation in a virtual environment.
>   

Yes, agreed.  The tsc is never the right thing to use if there's a
paravirt clocksource available.

What's wrong with rating it 300?  What inferior clocksource does it lose
out to?  Shouldn't that clocksource be lowered?  (Why don't we just use
1 to 10?)

    J
