Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYBSScu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYBSScu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYBSScm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:32:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49631 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752549AbYBSScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:32:41 -0500
Message-ID: <47BB20C6.7050205@sgi.com>
Date: Tue, 19 Feb 2008 10:32:38 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lameter@sgi.com
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
References: <200802162302.04131.yinghai.lu@sun.com> <p73ve4mxxlc.fsf@bingen.suse.de> <47BAFA66.2040603@sgi.com> <20080219180855.GB12010@one.firstfloor.org>
In-Reply-To: <20080219180855.GB12010@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Feb 19, 2008 at 07:48:54AM -0800, Mike Travis wrote:
>> Andi Kleen wrote:
>>> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>>>
>>>> we don't need copy too. already have x86_cpu_to_node_map
>>> That's a regression (probably from Mike's patches?). Until recently it was 
>>> used.
>> Yes, I had removed it because I couldn't find any references to it.
> 
> Hmm, maybe it regressed earlier. Sorry if I blamed you incorrectly.
> Anyways at some point this definitely worked. I remember writing
> the code ;-) 
> 
>> And reading one's own percpu variables should be as efficient as
>> reading one's own pda.
> 
> Sure, but the point is that getting the current node is a common
> operation, so it should be a single reference and not go through a 
> lookup table.
> 
> How it is actually implemented -- through PDA or through you new
> equivalent per cpu variables -- does not really matter as long 
> as the resulting code is only a single instruction. Using
> the lookup array from the cpu number is wrong.
> 
> My patch just fixed it back to use the PDA in the old style for now,
> but if all your per cpu stuff is merged (I admit I haven't tracked 
> if it is or not) replacing that with a per cpu variable would work too
> if it then generates the same code as with PDA.
> 
> -Andi

I'll look at it some more as I don't really have a preference either.
One thing that also bothered me was other cpus read the per cpu
variable to get the node number whilst the current cpu reads the pda
variable.  I'll see about resolving that quirky-ness.  (All one or all
the other.)

(And of course the problem with cpus on nodes with no local memory
needs to be resolved as well.)

Thanks,
Mike
