Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYBSSJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYBSSJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYBSSIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:08:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54069 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYBSSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:08:52 -0500
Date: Tue, 19 Feb 2008 19:08:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lameter@sgi.com
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
Message-ID: <20080219180855.GB12010@one.firstfloor.org>
References: <200802162302.04131.yinghai.lu@sun.com> <p73ve4mxxlc.fsf@bingen.suse.de> <47BAFA66.2040603@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BAFA66.2040603@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 07:48:54AM -0800, Mike Travis wrote:
> Andi Kleen wrote:
> > Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> > 
> >> we don't need copy too. already have x86_cpu_to_node_map
> > 
> > That's a regression (probably from Mike's patches?). Until recently it was 
> > used.
> 
> Yes, I had removed it because I couldn't find any references to it.

Hmm, maybe it regressed earlier. Sorry if I blamed you incorrectly.
Anyways at some point this definitely worked. I remember writing
the code ;-) 

> And reading one's own percpu variables should be as efficient as
> reading one's own pda.

Sure, but the point is that getting the current node is a common
operation, so it should be a single reference and not go through a 
lookup table.

How it is actually implemented -- through PDA or through you new
equivalent per cpu variables -- does not really matter as long 
as the resulting code is only a single instruction. Using
the lookup array from the cpu number is wrong.

My patch just fixed it back to use the PDA in the old style for now,
but if all your per cpu stuff is merged (I admit I haven't tracked 
if it is or not) replacing that with a per cpu variable would work too
if it then generates the same code as with PDA.

-Andi

