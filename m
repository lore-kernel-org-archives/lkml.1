Return-Path: <linux-kernel-owner+w=401wt.eu-S1765364AbYESWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765364AbYESWIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbYESWGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:06:01 -0400
Received: from gw.goop.org ([64.81.55.164]:57293 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765119AbYESWGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:06:00 -0400
Message-ID: <48320777.1000006@goop.org>
Date: Tue, 20 May 2008 00:04:23 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org> <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0805192217430.15410@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 17 May 2008, Theodore Tso wrote:
>   
>> On Sat, May 17, 2008 at 08:32:38PM +0200, Gabriel C wrote:
>>     
>>>> Which repository is commit 1c12c4cf in?
>>>>         
>>> It is in linus-git tree , http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
>>>       
>> ...post 2.6.26-rc2-git3.  For Linux kernels 2.6.26-rc2-git4 and
>> newer, you need to revert this commit or the X Server shipped with
>> Ubuntu Gutsy will die horribly when run on an X61s laptop with the
>> Intel 965GM video chipset.
>>
>> So the question is what's the right fix to keep the kernel compatible
>> with the X server, besides just reverting the commit entirely?
>>     
>
> [PATCH] x86: fix mprotect's NX handling on PAE
>
> 2.6.26-rc3 with CONFIG_X86_PAE may leave the NX bit set when PROT_EXEC
> is intending to clear it, causing irqbalance and others to segfault,
> and X startup to fail.
>
> This comes from an assumption in 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
> mprotect: prevent alteration of the PAT bits, that PTE_MASK is what it's
> supposed to be: whereas it's been wrong forever with PAE, staying 32-bit
> where 64-bit is needed.
>
> Jeremy Fitzhardinge already has patches to fix that in Ingo's tree;
> but if they're not considered 2.6.26 material, or people want a quick
> two-liner to get working, here's a shorter hack to fix up pte_modify.
>   

 From what I can tell, my patches haven't caused any regressions, and so 
if they fix a real bug we could consider them for .26.

    J
