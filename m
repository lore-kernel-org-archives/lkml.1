Return-Path: <linux-kernel-owner+w=401wt.eu-S1031047AbXDXI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031047AbXDXI0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031038AbXDXI0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:26:18 -0400
Received: from sd-green-bigip-207.dreamhost.com ([208.97.132.207]:56389 "EHLO
	spunkymail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031047AbXDXIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:25:45 -0400
X-Greylist: delayed 4846 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 04:25:45 EDT
Message-ID: <462DBEF6.70205@dawes.za.net>
Date: Tue, 24 Apr 2007 10:25:26 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Williams <pwil3058@bigpond.net.au>,
       ck list <ck@vds.kolivas.org>, Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net> <20070424073103.GA29054@elte.hu>
In-Reply-To: <20070424073103.GA29054@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rogan Dawes <lists@dawes.za.net> wrote:
> 
>>>        if (p_to && p->wait_runtime > 0) {
>>>                p->wait_runtime >>= 1;
>>>                p_to->wait_runtime += p->wait_runtime;
>>>        }
>>>
>>> the above is the basic expression of: "charge a positive bank balance". 
>>>
>> [..]
>>
>>> [note, due to the nanoseconds unit there's no rounding loss to worry 
>>> about.]
>> Surely if you divide 5 nanoseconds by 2, you'll get a rounding loss?
> 
> yes. But not that we'll only truly have to worry about that when we'll 
> have context-switching performance in that range - currently it's at 
> least 2-3 orders of magnitude above that. Microseconds seemed to me to 
> be too coarse already, that's why i picked nanoseconds and 64-bit 
> arithmetics for CFS.
> 
> 	Ingo

I guess my point was if we somehow get to an odd number of nanoseconds, 
we'd end up with rounding errors. I'm not sure if your algorithm will 
ever allow that.

Rogan
