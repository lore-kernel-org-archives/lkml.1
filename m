Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZAVD26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZAVD26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 22:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZAVD2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 22:28:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:35814 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbZAVD2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 22:28:48 -0500
Subject: Re: SET_PERSONALITY and TASK_SIZE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090118111831.GA4818@osiris.boeblingen.de.ibm.com>
References: <20090118111831.GA4818@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 14:28:23 +1100
Message-Id: <1232594903.23611.96.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> However we should use the PER_MASK if we want to check for PER_LINUX32,
> since there are more bits in the personality flags. In case any of the
> 'extra' bits is set we may incorrectly set personality to PER_LINUX even
> when we want PER_LINUX32.
> 
> Looks like more architectures should do something like:
> 
> 	if (personality(current->personality) != PER_LINUX32)

If you do gitk mm/memory.c, and look at the first 2 or 3 commits from
Hugh near the botto,, I -think- they may explain why you no longer see
the use of TASK_SIZE in there, ie, we may have fixed that in 2.6.12...

So from that point of view, it's quite possible that we no longer need
to defer the personality switch, which would allow to simplify things
quite a bit on ppc64, unless there is some -other- reason here...

Cheers,
Ben.


