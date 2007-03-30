Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbXC3TrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbXC3TrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXC3TrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:47:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38820 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752350AbXC3TrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:47:02 -0400
Date: Fri, 30 Mar 2007 21:47:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jikos@jikos.cz>,
       Lee Revell <rlrevell@joe-job.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       andrea@suse.de, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Message-ID: <20070330194701.GL14134@stusta.de>
References: <200703281847.05356.toralf.foerster@gmx.de> <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com> <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz> <20070328131454.cdb06bc3.akpm@linux-foundation.org> <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 11:16:39PM -0400, Kyle Moffett wrote:
> On Mar 28, 2007, at 16:14:54, Andrew Morton wrote:
> >On Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
> >Jiri Kosina <jikos@jikos.cz> wrote:
> >
> >>blockdev: bd_claim_by_kobject() could check value of unititalized  
> >>pointer
> >>
> >>Fixes this warning:
> >>
> >>fs/block_dev.c: In function `bd_claim_by_kobject':
> >>fs/block_dev.c:953: warning: 'found' might be used uninitialized  
> >>in this function
> >>
> >>struct bd_holder *found is initialized only when bd_claim()  
> >>returns zero. If it returns nonzero, ptr stays uninitialized.  
> >>Later the value of the pointer is checked.
> >
> >that generates extra code and people get upset.
> >
> >One approach which we could ue in here is
> >
> >	struct bd_holder *found = found;  /* Suppress bogus gcc warning */
> 
> Well, that would be correct except the warning is an actual kernel  
> bug.  Read Jiri's message (which you also quoted):
> >struct bd_holder *found is initialized only when bd_claim() returns  
> >zero. If it returns nonzero, ptr stays uninitialized. Later the  
> >value of the pointer is checked.
> 
> So in this case it has to be initialized to NULL or there's a  
> potential BUG() lurking.


No, the code is correct and it's impossible that the variable ever gets 
read uninitialized.

And BTW, i386 gcc 4.1 doesn't give me a warning for this.
Toralf, which gcc version and architecture did you see this with?


> Cheers,
> Kyle Moffett

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

