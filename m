Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXC1OJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXC1OJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXC1OJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:09:13 -0400
Received: from mail.suse.de ([195.135.220.2]:54427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXC1OJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:09:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than touching it
Date: Wed, 28 Mar 2007 16:09:04 +0200
User-Agent: KMail/1.9.5
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       John Hawkes <hawkes@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
References: <20070327214919.800272641@goop.org> <200703281550.04224.ak@suse.de> <460A74EF.6000700@redhat.com>
In-Reply-To: <460A74EF.6000700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281609.04956.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 16:00, Prarit Bhargava wrote:
> 
> >> touch_nmi_watchdog is attempting to tickle _all_ CPUs softlockup watchdogs.
> >>     
> >
> > It is supposed to only touch the current CPU, just like it only touches
> > the NMI watchdog on the current CPU.
> >
> >   
> 
> Andi,
> 
> (sorry for the cut-and-paste). 
> 
> touch_nmi_watchdogs sets EACH CPUs alert_counter to 0.

You're right. Sorry for the confusion.  

But just touching the current CPU would make much more sense. After all
the caller doesn't know anything about the state of other CPUs. Perhaps it would be best
to just change that and keep the softlockup semantics.

-Andi
