Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZLCXbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZLCXbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZLCXbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:31:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60908 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbZLCXbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:31:11 -0500
Date: Thu, 3 Dec 2009 17:31:17 -0600
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/2] GRU - function to generate  chipset IPI values
Message-ID: <20091203233117.GA13926@sgi.com>
References: <20091203223414.393107000@sgi.com> <20091203223549.730449000@sgi.com> <20091203151912.c99c4173.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203151912.c99c4173.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 03:19:12PM -0800, Andrew Morton wrote:
> On Thu, 03 Dec 2009 16:34:15 -0600
> steiner@sgi.com wrote:
> 
> > From: Jack Steiner <steiner@sgi.com>
> > 
> > Create a function to generate the value that is written to the UV hub
> > MMR to cause an IPI interrupt to be sent. The function will be
> > used in the GRU message queue error recovery code that sends IPIs to
> > nodes in remote partitions.
> > 
> > ...
> >
> > +static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
> > +{
> > +	return (1UL << UVH_IPI_INT_SEND_SHFT) |
> > +			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
> > +			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
> > +			(vector << UVH_IPI_INT_VECTOR_SHFT);
> > +}
> 
> You've taken care to avoid a shift overflow of "1", but not of
> `apicid', `vector' and `mode'.
> 
> Maybe the compiler does that, I forget.
 
I sure hate the 32/64 bit issues with shifts of ints. I am bitten by
that more than I'd like.

I think we are ok in this case.  In the above code, all of the fields
of the result except bit 63 reside in the low 32 bits of the resulting
unsigned long. I think that makes it work.

--- jack
