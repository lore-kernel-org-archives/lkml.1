Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbXJ2XNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbXJ2XNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXJ2XNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:13:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56403 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbXJ2XNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:13:05 -0400
Subject: Re: [PATCH] raise tsc clocksource rating
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
In-Reply-To: <20071029230213.GA1982@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com>
	 <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
	 <20071029224852.GA27547@elte.hu>
	 <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
	 <20071029230213.GA1982@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 16:13:58 -0700
Message-Id: <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 00:02 +0100, Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:

> > Not every guest support paravirt, but for correctness, all guests 
> > require TSC, which must be exposed all the way up to userspace, no 
> > matter what the efficiency or accuracy may be.
> 
> but if there's a perfect TSC available (there is such hardware) then the 
> TSC _is_ the best clocksource. Paravirt now turns it off unconditionally 
> in essence.

No, if no paravirt clocksource is detected, nothing can override the
perfect TSC hardware clocksource rating of 400.  And if a paravirt
clocksource is detected, it is always better than TSC.

> anyway, that's at most an optimization issue. No strong feelings here, 
> and we can certainly delay this patch until this gets all sorted out.

This patch should be nacked, since it is just wrong.  This is not an
optimization issue.  It is an accuracy issue for all virtualization
environments that affects long term kernel clock stability, which is
important to fix, and the best way to do that is to use a paravirt
clocksource.

Zach

