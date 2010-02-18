Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0BRU0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:26:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59920 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0BRU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:26:37 -0500
Date: Thu, 18 Feb 2010 21:26:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
	available
Message-ID: <20100218202627.GH5964@basil.fritz.box>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-10-git-send-email-luca@luca-barbieri.com> <87eikj54wp.fsf@basil.nowhere.org> <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com> <20100218101156.GE5964@basil.fritz.box> <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com> <4B7D5BB4.4000307@zytor.com> <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> memcpy/memset/etc. (assuming SSE is the best option for these at least
> on some processors) and checksums come to mind.

Typically SSE advantages only come to play with very large data sets,
and the kernel's are not big enough. I tried it some time ago.

That said you can already use kernel_fpu_begin/end of course
and it's used in some very rare cases.

> Also non-temporal SSE moves might be useful for things like memory
> compaction without clobbering caches.

You don't need SSE for non temporal moves.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
