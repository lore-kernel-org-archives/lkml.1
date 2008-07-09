Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYGIUGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYGIUGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYGIUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:05:51 -0400
Received: from gw.goop.org ([64.81.55.164]:54546 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYGIUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:05:50 -0400
Message-ID: <48751A0D.5020107@goop.org>
Date: Wed, 09 Jul 2008 13:05:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org>
In-Reply-To: <m1abgqzv3g.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I just took a quick look at how stack_protector works on x86_64.  Unless there is
> some deep kernel magic that changes the segment register to %gs from the ABI specified
> %fs CC_STACKPROTECTOR is totally broken on x86_64.  We access our pda through %gs.
>   

-mcmodel=kernel switches it to using %gs.

> Further -fstack-protector-all only seems to detect against buffer overflows and
> thus corruption of the stack.  Not stack overflows.  So it doesn't appear especially
> useful.
>   

It's a bit useful.  But at the cost of preventing a pile of more useful 
unification work, not to mention making all access to per-cpu variables 
more expensive.

> So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying to figure out
> how to use a zero based percpu area.
>   

Yes, please.

> That should allow us to make the current pda a per cpu variable, and use %gs with
> a large offset to access the per cpu area.  And since it is only the per cpu accesses
> and the pda accesses that will change we should not need to fight toolchain issues
> and other weirdness.  The linked binary can remain the same.
>   

Yes, and it would be functionally identical to the 32-bit code.

    J
