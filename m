Return-Path: <linux-kernel-owner+w=401wt.eu-S1763332AbYETLZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763332AbYETLZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYETLZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:25:03 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:6756 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbYETLZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:25:01 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
From: Andi Kleen <andi@firstfloor.org>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com>
Date: Tue, 20 May 2008 13:24:05 +0200
In-Reply-To: <1211125094-32167-1-git-send-email-avi@qumranet.com> (Avi Kivity's message of "Sun, 18 May 2008 18:38:14 +0300")
Message-ID: <87k5hpgqwa.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 May 2008 11:17:03.0261 (UTC) FILETIME=[07A574D0:01C8BA6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:

> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
> pointers in order to trap erronous use of freed list_heads.  Unfortunately
> userspace can arrange for those pointers to actually be dereferencable,
> potentially turning an oops to an expolit.
>
> To avoid this allow architectures (currently x86_64 only) to override
> the default values for these pointers with truly-undereferncable values.
> This is easy on x86_64 as the virtual address space is smaller than
> the range spanned by pointer values.

Hmm, thought I had sent a reply earlier, but don't see it so again.
My apologies if you see it twice.

The problem with your address values is that they're non canonical
and will result in a #GP, not #PF and oops handler cannot display
the address which will make them much less obvious.

I would rather use a guaranteed to be unmapped but canonical
address like in the ffffc10000000000 - ffffc1ffffffffff range
so that you still get page faults.

-Andi
