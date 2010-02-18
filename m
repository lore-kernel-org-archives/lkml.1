Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0BRKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:25:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:57435 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0BRKZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:25:55 -0500
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:24:49 +0100
Message-ID: <1266488689.26719.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 10:53 +0100, Luca Barbieri wrote:
> perf is currently the main user.
> On Core2, lock cmpxchg8b takes about 24 cycles and writes the
> cacheline, while movlps takes 1 cycle. 

Then run a 64bit kernel already, then its a simple 1 cycle read.

The only platform this might possibly be worth the effort for it Atom,
the rest of the world has moved on to 64bit a long time ago.

There might still be a few pentium-m users out there that might
appreciate this too, but still..

That said, _iff_ this can be done nicely there's no objection.

