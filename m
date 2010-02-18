Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0BRU2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:28:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60913 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0BRU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:27:59 -0500
Date: Thu, 18 Feb 2010 21:27:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jerome Glisse <glisse@freedesktop.org>,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       thellstrom@vmware.com, airlied@linux.ie, currojerez@riseup.net,
       linux-kernel@vger.kernel.org
Subject: Re: Uncool feature for TTM introduced by x86, pat: Use page flags
	to track memtypes of RAM pages
Message-ID: <20100218202753.GI5964@basil.fritz.box>
References: <20100218153032.GA4506@localhost.localdomain> <87aav65u9g.fsf@basil.nowhere.org> <4B7D7AF9.9060600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7D7AF9.9060600@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:38:01AM -0800, H. Peter Anvin wrote:
> On 02/18/2010 09:27 AM, Andi Kleen wrote:
> > Jerome Glisse <glisse@freedesktop.org> writes:
> >>
> >> Can we modify the interface to support again changing from uc to wc
> >> or wc to uc ? (i can try to do a patch for that).
> > 
> > At least on Intel CPUs that support self-snoop (all modern
> > ones) that should really be very cheap.
> > 
> 
> The UC/WC transition should be particularly trivial; I don't see any
> reason it should have to go through any other procedure on *any* CPU --
> selfsnoop shouldn't even figure into it, since neither UC nor WC
> actually caches anything.  For the WC->UC direction, all we should need
> to do is to flush the write combiners; a simple wmb() will do that.

I'm not sure that is sanctioned by the SDM rules; AFAIK they don't
make any special exception for this case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
