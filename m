Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831Ab0AXWiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0AXWiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809Ab0AXWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:38:43 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:40684 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab0AXWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=V5dwf6WvfLPXLOO6skuLxXDZEZseuZPuwXHbiL96bPvTtlz8ckvKljc+Q8dGUv3OIZ
         I3OjbQEPFGf4i/Xw20E7uKRb1Kr29qerKaOA82wrzrr6MTWXVCjyB7yykPcXRJ1q9aD/
         saZXQbWAlqoHdakmXlPcKLJznYEwIvxBbGz6M=
From: Don Mullis <don.mullis@gmail.com>
To: dedekind@infradead.org
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box>
	<87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org>
	<20100123082839.GB25842@discord.disaster>
	<20100123113551.GB29555@one.firstfloor.org>
	<20100123160537.GG25842@discord.disaster>
	<20100124205906.GC29555@one.firstfloor.org>
	<1264367435.2401.40.camel@localhost.localdomain>
Date: Sun, 24 Jan 2010 14:38:15 -0800
In-Reply-To: <1264367435.2401.40.camel@localhost.localdomain> (Artem
	Bityutskiy's message of "Sun, 24 Jan 2010 23:10:35 +0200")
Message-ID: <87ljfn9lig.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> Don made IMO a good proposal for the caller to add cond_reshed() in its
> 'cmp()' callback, if needed. Shouldn't that work fine?

In the list_sort() implementation I posted, there was an O(n) loop that
contained no calls back to cmp().  The V2 implementation I'm testing
right now fixes that -- all inner loops will call back to cmp().  It's
also a bit faster, though ~100 bytes bigger.

If there's any other objection to pushing responsibility for calling
cond_resched() back to the client, via the cmp() routine, please, let's
hear it.
