Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYHDPOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYHDPOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYHDPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:14:23 -0400
Received: from agminet02.oracle.com ([141.146.126.229]:12411 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYHDPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:14:22 -0400
X-Greylist: delayed 5257 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 11:14:22 EDT
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Austin Zhang <austin_zhang@linux.intel.com>, herbert@gondor.apana.org.au,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <1217846726.3454.589.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:45:37 -0400
Message-Id: <1217857537.29139.70.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:45 +0100, David Woodhouse wrote:
> On Mon, 2008-08-04 at 06:35 -0400, Austin Zhang wrote:
> > On Mon, 2008-08-04 at 11:12 +0100, David Woodhouse wrote:
> > > You could perhaps just use 'unsigned long' here, to avoid the ifdef.
> > Thanks. 
> > > And it would be nice if we could make libcrc32c use this too, rather
> > > than just the 'crypto' users.
> > From previous discussing, herbert would like to transfer the libcrc32c 
> > interface by new crypto because there were few user using the current 
> > libcrc32c interface. 
> 
> Are we deprecating libcrc32c, then? Or just turning it into a wrapper
> around the crypto code?
> 

Long term I'd like to switch btrfs to the crypto api, but right now I'm
using libcrc32c.

>From a performance point of view I'm probably reading the crypto API
code wrong, but it looks like my choices are to either have a long
standing context and use locking around the digest/hash calls to protect
internal crypto state, or create a new context every time and take a
perf hit while crypto looks up the right module.

Either way it looks slower than just calling good old libcrc32c.

-chris

