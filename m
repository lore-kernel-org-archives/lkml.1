Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXJ3Kwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXJ3Kwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXJ3Kw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:52:27 -0400
Received: from ozlabs.org ([203.10.76.45]:54763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbXJ3Kw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:52:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] raise tsc clocksource rating
Date: Tue, 30 Oct 2007 21:52:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net, John Stultz <johnstul@us.ibm.com>
References: <11936994092607-git-send-email-gcosta@redhat.com> <200710301339.23628.rusty@rustcorp.com.au> <20071030073736.GA21843@elte.hu>
In-Reply-To: <20071030073736.GA21843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302152.27077.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 18:37:36 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > No.  tsc is very good, it's not perfect.  If a paravirt clock
> > registers 400 it really means "pick me over the tsc".
>
> often the TSC is not perfect, but _IF_ it's perfect, using the paravirt
> driver is a pessimisation in performance.
>
> the main problem at the moment is that there's no mechanism at the
> moment to convey to the guest the information that the TSC is "perfect",
> and to convey the calibration values.

The host can communicate to the guest what clock to use: the guest can decide 
to register a paravirt clock or not depending on whether it wants to leave it 
to the TSC.

For a while we couldn't remove the TSC cpuid capability in the guest, because 
if you configured your kernel in some ways it was hardcoded on.  I think 
the "all 686+ have a tsc" assumption has now been fixed, so I should change 
the lguest clock to do as you said: register its clock at lower prio to the 
TSC and then the host can simply remove the TSC cpuid if it isn't suitable 
for the guest to use.

ISTR the core TSC timing code (which lguest could use) and various hardware 
manipulations (which lguest couldn't) were intertwined, but I'll have to go 
back and check exactly what the issue was.

> and just in case it's not obvious: i am not arguing for the inclusion of
> the patch

Unfortunately, you and Thomas both acked the patch.  This says v bad things 
about how much review kernel patches get.

Cheers,
Rusty.
