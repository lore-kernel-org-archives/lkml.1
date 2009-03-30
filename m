Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbZC3MqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbZC3MqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZC3MqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:46:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZC3MqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:46:05 -0400
Date: Mon, 30 Mar 2009 14:47:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
Message-ID: <20090330124735.GK11935@one.firstfloor.org>
References: <20090329155539.275927173@nick.local0.net> <20090329155750.062096365@nick.local0.net> <878wmnnr73.fsf@basil.nowhere.org> <20090330122712.GF31000@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330122712.GF31000@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:27:12PM +0200, Nick Piggin wrote:
> It's interesting. I suspect that with the size of the dcache hash,
> if we assume pretty random distribution of access patterns, then
> it might be unlikely to get much common cache lines (ok, birthday

The problem is that you increase the cache foot print overall
because these hash tables are gigantic. And because it's random
there will not be much locality. That is your hash table
might still fit when you're lucky, but then if the rest
of your workload needs a lot of cache too you might
end up with a cache miss on every access.

False sharing is not the issue with the big lock hash typically, that was 
more as an issue for a potential separate hash table design 
(I guess my original sentence was a bit confusing)

BTW the alternative would be to switch the hash table to some
large fan out tree indexed by the string hash value and then use
the standard lockless algorithms on that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
