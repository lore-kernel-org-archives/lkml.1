Return-Path: <linux-kernel-owner+w=401wt.eu-S936423AbXHIA0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936423AbXHIA0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763904AbXHIA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:26:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:52020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763669AbXHIA0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:26:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Date: Thu, 9 Aug 2007 02:26:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070808231719.GA7101@google.com>
In-Reply-To: <20070808231719.GA7101@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090226.24002.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 01:17:19 Aaron Durbin wrote:
> In setup_APIC_timer with the HPET in use, a condition can arise while
> waiting for the next irq slice to expire on the HPET which will either
> cause an NMI watchdog to fire or a 3 minute busy loop if the NMI
> watchdog is disabled.
> 
> The HPET comparator and the counter keep incrementing during its normal
> operation. When a comparison event fires the comparator will increment
> by the designated period. If the HPET trigger occurs right after
> the 'int trigger = hpet_readl(HPET_T0_CMP);' line, we will will spin
> for up to 3 minutes (with a clock of 25MHz) waiting for the HPET
> counter to wrap around. However, when the NMI watchdog is enabled the
> NMI watchdog will detect a lockup and reboot the machine. This
> scenario can be exasperated by the presence of an SMI which will
> increase the window of opportunity for the condition to occur.

Nasty.

Iirc the clockevents code did away with the synchronization
completely because Thomas determined it was useless because long term
it'll drift anyways. So perhaps it could be just removed?

-Andi
> 
