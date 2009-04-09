Return-Path: <linux-kernel-owner+w=401wt.eu-S934951AbZDIO4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951AbZDIO4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934771AbZDIOz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:55:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43434 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538AbZDIOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:55:24 -0400
Date: Thu, 9 Apr 2009 16:57:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, npiggin@suse.de,
       riel@redhat.com, lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM II
Message-ID: <20090409145746.GK14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org> <1239210239.28688.15.camel@think.oraclecorp.com> <20090409072949.GF14687@one.firstfloor.org> <20090409075805.GG14687@one.firstfloor.org> <1239283829.23150.34.camel@think.oraclecorp.com> <20090409140257.GI14687@one.firstfloor.org> <1239287859.23150.57.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239287859.23150.57.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even though try_to_releasepage only checks page_writeback() the lower
> filesystems all bail on dirty pages or dirty buffers (see the checks
> done by try_to_free_buffers).
> 
> It looks like the only way we have to clean a page and all the buffers
> in it is the invalidatepage call.  But that doesn't return success or
> failure, so maybe invalidatepage followed by releasepage?

Ok. I'll poke at it more.

> 
> I'll have to read harder next week, the FS invalidatepage may expect
> truncate to be the only caller.

I have to be careful with locks; another lock would deadlock. Ok
I could drop the page lock temporarily, but that would be somewhat
risky of someone else coming in unexpectedly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
