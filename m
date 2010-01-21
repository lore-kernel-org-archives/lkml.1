Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887Ab0AUGem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0AUGem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445Ab0AUG3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:29:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38548 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0AUG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:29:10 -0500
Message-ID: <4B57F421.4070409@zytor.com>
Date: Wed, 20 Jan 2010 22:28:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com> <alpine.DEB.2.00.1001201443340.17915@router.home> <alpine.LFD.2.00.1001201546330.13231@localhost.localdomain> <4B579985.8040504@zytor.com>
In-Reply-To: <4B579985.8040504@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 04:02 PM, H. Peter Anvin wrote:
> On 01/20/2010 03:57 PM, Linus Torvalds wrote:
>>
> 
> I'm somewhat unhappy about that notion, mostly because it means Yet
> Another Thing To Verify[TM].  I would like to look at the relative code
> sizes of 2^31 and 2^30, however, if all it means is that *one*
> instruction in *one* asm has to be different, I'd rather leave it at 2^31.
> 

Well, there is no size difference within measurable limits (an
x86-64-allyesconfig build is 60(!) bytes larger with 2^31 and the incl,
but that's well within the good luck/bad luck with alignments threshold...)

As such, I'd personally prefer to leave it with 1:31:31:1 split, if
nothing else because it reads a bit tidier to me, despite the minor wart
for the incl trick.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

