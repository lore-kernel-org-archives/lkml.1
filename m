Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXJWQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXJWQz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXJWQzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:55:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbXJWQzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:55:18 -0400
Date: Tue, 23 Oct 2007 09:55:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Philippe Elie <phil.el@wanadoo.fr>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
In-Reply-To: <20071023161321.GA2884@zaniah>
Message-ID: <alpine.LFD.0.999.0710230951170.30120@woody.linux-foundation.org>
References: <20071021120842.GA2886@zaniah>
 <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org>
 <20071023101007.3y62tufa6yxrqk4w@m.safari.iki.fi>
 <20071023161321.GA2884@zaniah>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Philippe Elie wrote:
> 
> For the signed-offs I thought the From: was an implicit Signed-offs.

No, there are no implicit sign-offs. The point of sign-offs is that it 
makes the copyright and flow of patches explicit, so an "implicit 
sign-off" would defeat the whole point.

> Test was done privately, Sami helped to narrow down the trouble, but
> he didn't test the last patch, nothing bad on Sami side, I was too
> confident the fix was obvious after narrowing it.

Well, I just wanted an ack that it was tested, since it seemed a bit 
subtle and (like the sign-offs) that explicit "yes, this was tested" was 
missing. Looks like I was right in asking for it:

> > The previous patch I tested by Philippe, oprof-fix-profile_pc-use.patch,
> > worked ok, but with this latest patch oprofiled aborts.
> > But kernel does not oops or print msgs.
> 
> argh, I just moved the wrong eip from kernel to user space where the same
> problem occur too, *sighs*, since I can't reproduce Sami problem, my own
> test obviously worked...
> 
> Sami, can you test this new patch. After testing can you report
> the contents of /dev/oprofile/stats/cpu*/sample_invalid_eip ?
> 
> Linus, there is two way to fix this problem, the attached patch fix it
> by sanitizing the sampled eip,

I'm perfectly happy with the attached patch, I just want it to be 
properly tested and have all the sign-offs (and explanations etc) in 
place, and I can apply it.

Of course, I cannot think of a single architecture where an EIP of ~0UL is 
valid anyway, so I'm also not opposed to just keeping ~0UL as the magic 
value.

		Linus
