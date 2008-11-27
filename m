Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYK0V2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYK0V2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYK0V1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:27:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39262 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYK0V1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:27:53 -0500
Message-ID: <492F0FEB.50805@cs.helsinki.fi>
Date: Thu, 27 Nov 2008 23:23:55 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>  <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>  <Pine.LNX.4.64.0811271349040.21910@blonde.site> <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com> <Pine.LNX.4.64.0811271643250.9618@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0811271643250.9618@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Hugh Dickins wrote:
> Reverting my patch for now: that's certainly a reasonable possibility,
> but leaves us with several other such bugs.  Suggested patch below,
> but the ftrace part of it worries me a little, since it's within a
> structure and maybe it's a bad idea to enlarge that at this point;
> I've also not _really_ done the arithmetic needed for the slub one.

For SLUB, I think you can just replace the 100 with KSYM_NAME_LEN and it 
will work fine. The 100 constant is already supposed to be big enough to 
fit the symbol and the rest.

Hugh Dickins wrote:
> An alternative quick just-for-now fix might be to remove that
> 	namebuf[KSYM_NAME_LEN - 1] = 0;
> from kallsyms_lookup(): as I understand it (please check), that
> could only make sense in cases where the symbol is KSYM_NAME_LEN
> long or longer - in which case, all of the places fixed in the
> patch below would be causing corruption already, even without my
> patch.  I think.  Maybe that "= 0" even serves no purpose at all?

I like this approach the best but I worry it's a can of worms especially 
this late in the cycle.

As a stop-gap measure, I'm fine with your proposed patch either as-is or 
with the suggestions I had for the SLUB case.

		Pekka
