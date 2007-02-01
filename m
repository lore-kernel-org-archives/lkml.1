Return-Path: <linux-kernel-owner+w=401wt.eu-S1422876AbXBANvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422876AbXBANvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422877AbXBANvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:51:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:59309 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422876AbXBANvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:51:36 -0500
Date: Thu, 1 Feb 2007 14:54:45 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 8/9] Add time_update_mt_guess()
Message-ID: <20070201135442.GP21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.136630000@jet.suse.cz> <200702011228.50435.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011228.50435.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:28:50PM +0100, Andi Kleen wrote:
> On Thursday 01 February 2007 11:00, jbohac@suse.cz wrote:
> > +inline u64 mt_to_nsec(u64 mt)
> > +{
> > +	u64 ret;
> > +	ret  = ((mt & 0xffffff) * vxtime.mt_q) >> 32;
> > +	mt >>= 24;
> > +	ret += ((mt & 0xffffff) * vxtime.mt_q) >> 8;
> > +	mt >>= 24;
> > +	ret += ( mt             * vxtime.mt_q) << 16;
> > +	return ret;
> 
> Why so complicated? Isn't a single multiply good enough?

This does a multiplication and a downshift at once. The problem
is, that if we first do the multipclication, the result won't fit
in 64 bits.

If we first do the downshift, we lose precision.

This does both operations at once, avoiding both the overflow and
underflow.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

