Return-Path: <linux-kernel-owner+w=401wt.eu-S934504AbZLGWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbZLGWOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbZLGWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:14:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310AbZLGWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:14:37 -0500
Date: Mon, 7 Dec 2009 14:13:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations truly no-ops when
 disabled
Message-Id: <20091207141356.9e83fd5b.akpm@linux-foundation.org>
In-Reply-To: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com>
References: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Dec 2009 18:42:13 +0100
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> It turns out that even zero-sized struct members (int foo[0];) will affect
> the struct layout, causing us in particular to lose 4 bytes in struct sock.
> 
> This patch fixes the regression in CONFIG_KMEMCHECK=n case.

Which kernel version is the regression relative to?

Should we backport this into 2.6.32.x?

If so, we have a slight problem: someone did
s/MAYBE_BUILD_BUG_ON/BUILD_BUG_ON/ in linux-next (I have feeling it was
me ;)) so the patch I applied had that slight massaging.  Perhaps the
-stable stalwarts can take care of that slight difference.

