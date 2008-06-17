Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYFQVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYFQVAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYFQVAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:00:00 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:16017 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbYFQU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:59:59 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386, bisected, reproducable)
From: Andi Kleen <andi@firstfloor.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com>
	<1213682570.13708.1258839317@webmail.messagingengine.com>
	<alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
	<alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
Date: Tue, 17 Jun 2008 22:58:17 +0200
In-Reply-To: <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> (Linus Torvalds's message of "Tue, 17 Jun 2008 13:16:39 -0700 (PDT)")
Message-ID: <87od5zwzh2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jun 2008 20:51:03.0131 (UTC) FILETIME=[DAF992B0:01C8D0BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>
> So I'm starting to think the bug is all in there, not in the VM itself. 
> See arch/x86/lib/copy_user_nocache.S.

The x86-64 copy_*_user functions were always designed to return errors
both ways (as in both for load and for store). That's needed because
the loops are shared for copy_to_user and copy_from_user. That's normally
ok because when you do _to_user you shouldn't fault on the loads
and vice versa. If a caller does that it's buggy.

-Andi
