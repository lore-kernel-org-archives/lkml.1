Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXCUNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXCUNIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXCUNIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:08:19 -0400
Received: from www.osadl.org ([213.239.205.134]:47878 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752789AbXCUNIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:08:18 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211137.10884.ak@suse.de>
	 <1174475666.10840.44.camel@localhost.localdomain>
	 <200703211342.59093.ak@suse.de>
	 <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 14:15:29 +0100
Message-Id: <1174482929.10840.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 14:04 +0100, Stefan Prechtel wrote:
> I uploaded the output of dmesg (kernel 2.6.21-rc4-git5) (battery / ac)
> and dmidecode
> I can boot on battery with nolapic_timer and the second core is online, too.
> /proc/acpi/processor/C000/ shows the same as before but
> /proc/interrupts has changed:
> 
> (battery)
>            CPU0       CPU1
>   0:      47131          0  local-APIC-edge-fasteoi   timer
> LOC:          0      46978
> 
> (ac)
>            CPU0       CPU1
>   0:      59137          0  local-APIC-edge-fasteoi   timer
> LOC:          0      58984

That's correct. We keep the PIT alive and trigger the lapic timer
interrupt via an IPI.

	tglx


