Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXC1Nua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXC1Nua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXC1Nua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:50:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:49714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXC1Nua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:50:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than touching it
Date: Wed, 28 Mar 2007 15:50:04 +0200
User-Agent: KMail/1.9.5
Cc: Prarit Bhargava <prarit@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       John Hawkes <hawkes@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
References: <20070327214919.800272641@goop.org> <20070327215828.085422178@goop.org> <460A6EC0.4020701@redhat.com>
In-Reply-To: <460A6EC0.4020701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281550.04224.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 15:33, Prarit Bhargava wrote:
> 
> Jeremy Fitzhardinge wrote:
> >
> > I haven't really worked out how this should interact with the nmi
> > watchdog; touch_nmi_watchdog() still ends up calling
> > touch_softlockup_watchdog(), so there's still some redundancy here.
> >
> >   
> 
> touch_nmi_watchdog is attempting to tickle _all_ CPUs softlockup watchdogs.

It is supposed to only touch the current CPU, just like it only touches
the NMI watchdog on the current CPU.


> 
> Currently, the code is incorrect -- it is calling 
> touch_softlockup_watchdog which touches only the current CPU's 
> softlockup watchdog.

Sounds correct to me.

-Andi

> 
