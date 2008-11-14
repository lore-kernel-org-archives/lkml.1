Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKNAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKNAzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYKNAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:55:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:35561 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYKNAz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:55:27 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, cloos@jhcloos.com, paul@burly.ondioline.org,
       torvalds@linux-foundation.org
In-Reply-To: <20081113.151116.139760511.davem@davemloft.net>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <20081113.151116.139760511.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 11:54:20 +1100
Message-Id: <1226624060.7178.100.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 15:11 -0800, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Mon, 10 Nov 2008 16:46:25 +1100
> 
> > David, would you mind testing on your machine ? It's the one that shows
> > the biggest performance improvement, and I would like to know how much
> > it is affected by that patch. As long as the "worst case" performance
> > is still reasonable, I'm ok to take the hit if the improvement for you
> > is still significant.
> 
> Finally got around to this, we lose about a full second in the
> "cat rfc3261.txt" benchmark:
> 
> 2.6.28-rc4 vanilla:
> 
> 7.634
> 7.704
> 7.688
> 
> 2.6.28rc4+patch:
> 
> 8.712
> 8.685
> 8.702

How does it compare with not having the acceleration ? ie. I don't think
I can do anything about it, except maybe optimize for the case where the
pixmap is already aligned (and thus doesn't need scissors), the main
question is is the acceleration still worth it or not at all since it's
generally not worth it on other architectures.

Cheers,
Ben.


