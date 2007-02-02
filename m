Return-Path: <linux-kernel-owner+w=401wt.eu-S1423187AbXBBHWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423187AbXBBHWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXBBHVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423173AbXBBHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:27 -0500
From: Andi Kleen <ak@suse.de>
To: Jiri Bohac <jbohac@suse.cz>
Subject: Re: [patch 9/9] Make use of the Master Timer
Date: Fri, 2 Feb 2007 08:04:29 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de,
       Recent@suse.de, Addresses@suse.de
References: <20070201095952.589234000@jet.suse.cz> <200702011236.05429.ak@suse.de> <20070201142927.GR21755@dwarf.suse.cz>
In-Reply-To: <20070201142927.GR21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020804.29824.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 15:29, Jiri Bohac wrote:

> If I do:
> 	rdtscll(a)
> 	...
> 	rdtscll(b)
> is it guaranteed that (b > a) ?

It's not architecturally -- unless you have a barrier.

On P4 the micro architecture guarantees it, but there the barrier in
get_cycles_sync is  patched away. On other x86-64s it is generally needed.

The effect can be also seen between CPUs.

> Because of the __vxtime.cpu[cpu].tsc_invalid flag. We may be

You can still precompute it for the HPET etc. case.
They are already slow, but saving a condition there might be still
worth it.

-Andi
