Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYCKCQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYCKCQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYCKCQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:16:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbYCKCQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:16:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
In-Reply-To: Oleg Nesterov's message of  Sunday, 9 March 2008 21:59:26 +0300 <20080309185926.GA5649@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru>
X-Shopping-List: (1) Pedantic friction expectations
   (2) Bucolic compassion caves
   (3) Horn-rimmed commission expulsions
Message-Id: <20080311021633.BF1B326F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:16:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think your logic is sound.  But for paranoia's sake I would add
a BUG_ON(signal->flags & SIGNAL_GROUP_EXIT) in the group-fatal case.

I don't really like dropping the signal on the floor.  If the posting says
it succeeded (vs -ESRCH) then I'd like to see it appear later in the
pending set of the zombie thread, when we look at /proc/pid/status at exit
tracing or whatnot (and in core dumps).  Seeing those pending signal bits
is sometimes a useful clue about how something died in a strange scenario.


Thanks,
Roland
