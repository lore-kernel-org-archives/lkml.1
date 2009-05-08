Return-Path: <linux-kernel-owner+w=401wt.eu-S1763989AbZEHUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763989AbZEHUx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbZEHUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:52:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761638AbZEHUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:52:57 -0400
Message-ID: <4A049B99.4000402@zytor.com>
Date: Fri, 08 May 2009 13:52:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com> <4A03F016.76EA.0078.0@novell.com> <874ovvo0wo.fsf@basil.nowhere.org> <4A0492EA.6080403@zytor.com> <20090508205347.GC23223@one.firstfloor.org>
In-Reply-To: <20090508205347.GC23223@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, May 08, 2009 at 01:15:38PM -0700, H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>> "Jan Beulich" <jbeulich@novell.com> writes:
>>>> Why blindly? Aren't hotpluggable memory ranges supposed to be reserved
>>>> in the E820 map?
>>> They are supposed to be reserved in SRAT, but not in e820.
>> Ah, okay.  Perhaps we should fold this information into our internal 
>> "e820" map?  If so I guess the question is how soon we can do that.
> 
> You could do that or just query SRAT too, but ...
> 
> The problem is really that there are still systems which have hidden
> holes which are not reserved anywhere. When I last hacked on the gap algorithm
> it triggered subtle bugs. So this will never be fully reliable.
> 

That's without a question.

However, as far as querying SRAT, I don't like the idea of spreading the 
knowledge of the system memory map out between a bunch of different 
places, each of which have a little piece of the puzzle.  It puts a huge 
onus on the user to know what mechanisms are actually available, and 
really makes a shitty interface.

	-hpa
