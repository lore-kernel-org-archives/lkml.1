Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXJ3MB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXJ3MB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXJ3MBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:01:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbXJ3MBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:01:18 -0400
Message-ID: <47271D4A.8030707@redhat.com>
Date: Tue, 30 Oct 2007 10:02:18 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rusty@rustcorp.com.au, jeremy@goop.org,
       --cc@redhat.com, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com>	 <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>	 <20071029224852.GA27547@elte.hu>	 <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>	 <20071029230213.GA1982@elte.hu> <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Zachary Amsden escreveu:
> On Tue, 2007-10-30 at 00:02 +0100, Ingo Molnar wrote:
>> * Zachary Amsden <zach@vmware.com> wrote:
> 
>>> Not every guest support paravirt, but for correctness, all guests 
>>> require TSC, which must be exposed all the way up to userspace, no 
>>> matter what the efficiency or accuracy may be.
>> but if there's a perfect TSC available (there is such hardware) then the 
>> TSC _is_ the best clocksource. Paravirt now turns it off unconditionally 
>> in essence.
> 
> No, if no paravirt clocksource is detected, nothing can override the
> perfect TSC hardware clocksource rating of 400.  And if a paravirt
> clocksource is detected, it is always better than TSC.

Why always? tsc is the best possible alternative the _platform_ can
provide. So the paravirt clocksource will be at best, as good as tsc.
And if it is the case: why bother with communication mechanisms of all
kinds, calculations, etc, if we can just read the tsc?

Noting again: If the tsc does not arrive accurate to the guest, it will
fail the tsc clocksource tests. So it will be rated zero anyway



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHJx1KjYI8LaFUWXMRAv0hAJ4sj0Z1FraYrgbU5Mj0pWOJGk6jtwCfc5xL
jpTC273X0oqPTCR7NcVHJOI=
=WPzV
-----END PGP SIGNATURE-----
