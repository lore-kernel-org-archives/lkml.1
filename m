Return-Path: <linux-kernel-owner+w=401wt.eu-S1423066AbXDXUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423066AbXDXUAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423080AbXDXUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:00:31 -0400
Received: from gw.goop.org ([64.81.55.164]:53702 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423066AbXDXUAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:00:30 -0400
Message-ID: <462E61F1.7060403@goop.org>
Date: Tue, 24 Apr 2007 13:00:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
References: <20070327214919.800272641@goop.org>	<20070327215827.871954359@goop.org>	<20070423234910.50149faf.akpm@linux-foundation.org>	<462E43A7.1050001@goop.org>	<20070424105738.e0ce36a9.akpm@linux-foundation.org>	<462E4969.6070802@goop.org> <20070424113222.ed2e1314.akpm@linux-foundation.org>
In-Reply-To: <20070424113222.ed2e1314.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well, it _is_ mysterious.
>
> Did you try to locate the code which failed?  I got lost in macros and
> include files, and gave up very very easily.  Stop hiding, Ingo.
>   

OK, I've managed to reproduce it.  Removing the local_irq_save/restore
from sched_clock() makes it go away, as I'd expect (otherwise it would
really be magic).  But given that it never seems to touch the softlockup
during testing, I have no idea what difference it makes...

    J
