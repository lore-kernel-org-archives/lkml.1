Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXJ2Wz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXJ2Wz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXJ2Wzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:55:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXJ2Wzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:55:50 -0400
Date: Mon, 29 Oct 2007 23:55:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       --cc@redhat.com, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029225528.GA31293@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47266431.1010500@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > if it's inaccurate why are you exposing it to the guest then? Native 
> > only uses the TSC if it's safe and accurate to do so.
> 
> It is used as part of the Xen clocksource as a short term 
> extrapolator, with correction parameters supplied by the hypervisor.  
> It should never be used directly.

that's totally broken then. You cannot create an SMP-safe monotonic 
clocksource via interpolation - native does not do it either. Good thing 
this problem got exposed, it needs to be fixed.

	Ingo
