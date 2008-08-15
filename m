Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYHONOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYHONOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHONOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:14:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48313 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYHONOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:14:08 -0400
Date: Fri, 15 Aug 2008 15:15:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
Message-ID: <20080815131530.GG19125@one.firstfloor.org>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 01:58:32PM +0100, Hugh Dickins wrote:
> Do we actually want these DirectMap lines in the x86 /proc/meminfo?
> I can see they're interesting to CPA developers and TLB optimizers,
> but they don't fit its usual "where has all my memory gone?" usage.

It was intended for the "why is my computer going slower" usage.

> If they are to stay, here are some fixes.
> 
> 1. On x86_32 without PAE, they're not 2M but 4M pages: no need to
>    mess with the internal enum, but show the right name to users.
> 
> 2. Many machines can never show anything but 0 for DirectMap1G,
>    so suppress that line unless direct_gbpages are really enabled.

I made them unconditional to minimize the risk of some dumb
parser not being able to deal with them. Longer term there
will be more and more machines that support them.

Admittedly that's not a very strong argument.

-Andi
