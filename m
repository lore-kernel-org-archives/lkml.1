Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbZA3CNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbZA3CNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZA3CNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:13:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:59827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZA3CNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:13:34 -0500
Subject: Re: 2.6.28-rt on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: avorontsov@ru.mvista.com
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 13:11:50 +1100
Message-Id: <1233281510.18767.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is trivially solved by converting arch/powerpc/sysdev/ipic.c
> back to spinlocks (ipic_lock).
> 
> Assuming that converting-back is automatic, there are few other
> chained interrupt controllers you might want to convert-back:
> 
> arch/powerpc/sysdev/i8259.c (i8259_lock)
> arch/powerpc/sysdev/mpic.c (mpic_lock)
> arch/powerpc/sysdev/qe_lib/qe_ic.c (qe_ic_lock)

Except that a bunch of those can be both primary and chained... It's
simply not a solution to have to "convert" interrupt controller code to
use a different locking scheme depending on whether they are chained or
primary...

Cheers,
Ben.


