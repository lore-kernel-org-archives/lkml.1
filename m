Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbXJQV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbXJQV0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXJQV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:26:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbXJQV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:26:21 -0400
Date: Wed, 17 Oct 2007 14:25:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Karsten Keil <kkeil@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de, stable@kernel.org
Subject: Re: [PATCH] [ISDN] Fix random hard freeze with AVM c4 card
Message-Id: <20071017142556.0fda897f.akpm@linux-foundation.org>
In-Reply-To: <20071017110744.GA6687@pingi.kke.suse.de>
References: <20071017110744.GA6687@pingi.kke.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 13:07:44 +0200
Karsten Keil <kkeil@suse.de> wrote:

> The patch
> - Includes the call to capilib_data_b3_req in the spinlock. This routine
>   in turn calls the offending mq_enqueue routine that triggered the
>   freeze if not locked.  This should also fix other indicators of
>   incosistent capilib_msgidqueue list, that trigger messages like:
>   Oct  5 03:05:57 BERL0 kernel: kcapi: msgid 3019 ncci 0x30301 not on queue
>   that we saw several times a day (usually several in a row).
> - Fixes all occurrences of c4_dispatch_tx to be called with active
>   spinlock, there were some instances where no lock was active. Mostly
>   these are in very infrequently called routines, so the additional
>   performance penalty is minimal.

I've tagged this patch and "[ISDN] fix random freezes with AVM B1 drivers"
as suitable for backporting into 2.6.23.x.  Please let me know if that was
not appropriate.
