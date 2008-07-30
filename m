Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYG3BnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYG3BnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYG3Bmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:42:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60062 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYG3Bmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:42:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
	<m1bq0g8euy.fsf@frodo.ebiederm.org> <488FAAD9.4090907@goop.org>
	<m1vdyo44v4.fsf@frodo.ebiederm.org> <488FBAEC.5000306@goop.org>
Date: Tue, 29 Jul 2008 18:36:37 -0700
In-Reply-To: <488FBAEC.5000306@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 29 Jul 2008 17:50:52 -0700")
Message-ID: <m1fxps17bu.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4246]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> Generally easy except for the disparate methods of catching interrupts.
>>
>
> Catching in what sense?  I assume the interrupt gets raised in some
> source-specific way, and then passed into a generic layer where it eventually
> gets matched with an appropriate handler.  I'm sure there's some subtlety I'm
> missing.

Sorry.  Probably too much context in my head.
The model I use is irq sources throw interrupts and then the cpus catch them.
Sometimes those in flight irqs go through several transformations.

Given that the event channels that logical irq are bound to change over time
I would say they appear to be not irq sources.  Those are the physical
lines coming out of hardware devices (if physical), and the equivalent
parts of the hardware when the irqs are sent message based.

So it does sound like the event channels function much like vectors.  Which
are the token thrown from ioapics to cpus to tell them which irq has happened
but have nothing to do with it.

The sources and the linux irq numbers should be stable if you don't unplug
anything.  The rest are implementation details the architecture should hide.

In that case I don't see any reason we could not be receiving irqs with the
cpus catching vectors and with events showing up in event channels.  Having
both running at the same time is a little odd but doable.

Eric
