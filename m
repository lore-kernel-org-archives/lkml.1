Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYKEURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYKEURZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYKEURQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:17:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:49382 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbYKEURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=cyvlVDaDRhcgWxpV4350Clsu3sMrD5y2R89jYLXWQXC+td76hEKiwcEntBGKPVVeLK
         gufyGE+Ce5WjIOjfWcZeuhzJ+5cYRARss4+kKtzPkXU47pD/u8kVjbBu+BXoY10sd5dt
         yGqCtr7QKwpsjC0XD+yCbDmIgiGYFKgsniO7g=
Date: Wed, 5 Nov 2008 23:20:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
Message-ID: <20081105202014.GA11782@x200.localdomain>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org> <20081105172312.GA10585@x200.localdomain> <20081105191628.GC6561@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081105191628.GC6561@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:16:29PM +0100, Jörn Engel wrote:
> [ Threading should have been broken.  Doh! ]
> 
> On Wed, 5 November 2008 20:23:12 +0300, Alexey Dobriyan wrote:
> > On Wed, Nov 05, 2008 at 05:39:41PM +0100, Jörn Engel wrote:
> > > Hardly any file in the kernel can be compiled without including
> > > <linux/types.h>, directly or indirectly.  And I'd wager a beer that
> > > noone can find a non-trivial example.  I couldn't.
> > 
> > This is only going to slow down compilation and types.h is not causing much
> > compilation problems, in fact, I can't recall a compilation problem due to
> > types.h. Contary to config.h situation which was a pain.
> 
> My hope was actually to speed up compilation.  If the average c file
> includes 10 headers, on types.h will get included by most of them,
> possibly multiple times.  Each run after the first still has to parse
> the whole file, just to drop everything between  #ifndef _LINUX_TYPES_H
> and #endif.
> 
> By passing types.h on the command line we can drop it from all headers
> and only have to parse it once.  Just the intermediate step of parsing
> types.h 11 times instead of 10 will slow things down.  By about .4% on
> my not very beefy notebook.
> 
> Before:
> real    4m33.241s
> user    3m58.524s
> sys     0m18.539s
> 
> After:
> real    4m29.707s
> user    3m59.674s
> sys     0m18.182s

Could be anything.
