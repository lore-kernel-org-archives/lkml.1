Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXAXRFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXAXRFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXAXRFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:05:39 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:47066 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbXAXRFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:05:38 -0500
Date: Wed, 24 Jan 2007 12:00:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linuxppc-dev@ozlabs.org,
       Douglas Niehaus <niehaus@eecs.ku.edu>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 7/10] local_t : powerpc
Message-ID: <20070124170022.GE4979@Krystal>
References: <20061221001545.GP28643@Krystal> <20061221002705.GW28643@Krystal> <17847.8700.118329.777644@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <17847.8700.118329.777644@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 11:59:50 up 154 days, 14:07,  4 users,  load average: 0.42, 0.74, 0.69
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > +static __inline__ int local_dec_if_positive(local_t *l)
> > +{
> > +	int t;
> > +
> > +	__asm__ __volatile__(
> > +"1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
> > +	addic.	%0,%0,-1\n\
> > +	blt-	2f\n"
> > +	PPC405_ERR77(0,%1)
> > +"	stwcx.	%0,0,%1\n\
> > +	bne-	1b"
> 
> This has the same bugs that we fixed recently in atomic_dec_if_positive;
> first, on 64-bit machines, the lwarx will zero-extend the word loaded
> from memory, and so the result of the addic will be negative only if
> the word was originally 0.  Secondly, even on 32-bit machines,
> 0x80000000 will be considered positive since decrementing it gives
> 0x7fffffff, which is positive.
> 
Hi Paul,

Thanks, will fix.

Mathieu

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
