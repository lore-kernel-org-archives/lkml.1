Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXJ2Wl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXJ2Wl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJ2WlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:41:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47560 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXJ2WlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:41:22 -0400
Subject: Re: [PATCH] raise tsc clocksource rating
From: Zachary Amsden <zach@vmware.com>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, mingo@elte.hu, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
In-Reply-To: <11936994092607-git-send-email-gcosta@redhat.com>
References: <11936994092607-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 15:42:14 -0700
Message-Id: <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 20:10 -0300, Glauber de Oliveira Costa wrote:
> From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> 
> tsc is very good time source (when it does not have drifts, does not
> change it's frequency, i.e. when it works), so it should have its rating
> raised to a value greater than, or equal 400.
> 
> Since it's being a tendency among paravirt clocksources to use values
> around 400, we should declare tsc as even better: So we use 500.

Why is the TSC better than a paravirt clocksource?  In our case this is
definitely inaccurate.  Paravirt clocksources should be preferred to
TSC, and both must be made available in hardware for platforms which do
not support paravirt.

Also, please cc all the paravirt developers on things related to
paravirt, especially things with such broad effect.  I think 400 is a
good value for a perfect native clocksource.  >400 should be reserved
for super-real (i.e. paravirt) sources that should always be chosen over
a hardware realistic implementation in a virtual environment.

Zach

