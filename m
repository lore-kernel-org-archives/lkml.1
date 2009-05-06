Return-Path: <linux-kernel-owner+w=401wt.eu-S1760467AbZEFQNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467AbZEFQNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZEFQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:12:50 -0400
Received: from [192.16.179.4] ([192.16.179.4]:35551 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZEFQMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:12:49 -0400
Date: Thu, 07 May 2009 01:09:34 +0900 (JST)
Message-Id: <20090507.010934.91933700.ryusuke@osrg.net>
To: viro@ZenIV.linux.org.uk
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: sget() misuse in nilfs
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090506.152859.91114993.ryusuke@osrg.net>
References: <20090506.003729.89601025.ryusuke@osrg.net>
	<20090505163737.GL8633@ZenIV.linux.org.uk>
	<20090506.152859.91114993.ryusuke@osrg.net>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 01:09:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, 06 May 2009 15:28:59 +0900 (JST), Ryusuke Konishi wrote:
> If we treat read-only mount as the latest snapshot at the time (though
> we didn't take this interpretation), the transitions can be reduced
> to:
> 
>  * r/w -> r/w.  Allowed.
>  * r/w -> snapshot.  Allowed if no checkpoint number was given (or the
>                      latest checkpoint was specified)
>  * snapshot -> r/w.  Allowed if it's the latest one and no r/w is there.
>  * snapshot -> snapshot.  Only if it's the same.
> 
> Right?

Ah, I had forgotten garbage collection (GC).

GC can break checkpoints which are not marked as snapshot.  ro-mount
cannot coexist with rw-mount because GC works while an rw-mount is
there.

Sorry, the above interpretation was not easily realized.
 
> But it still needs test_exclusive_mount().
> 
> The test_exclusive_mount() may be eliminable by adding rw-mount-exists
> flag on the_nilfs struct.  I'll take some thinking.

The elimination of test_exclusive_mount() was possible by this method
if we can treat ro-mount as the latest checkpoint at the time.

I'd like to consider if a similiar elimination is possible in case
that ro-mount and rw-mount cannot coexist.

Regards,
Ryusuke Konishi
