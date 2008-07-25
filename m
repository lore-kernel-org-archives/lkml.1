Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYGYVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYGYVxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYGYVxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:53:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42901 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYGYVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:53:00 -0400
Date: Fri, 25 Jul 2008 14:52:51 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, mingo@elte.hu,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] hugetlb: fix CONFIG_SYSCTL=n build
Message-ID: <20080725215251.GA20574@us.ibm.com>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp> <20080721191519.GA15843@elte.hu> <20080721214258.787a67ca@lxorguk.ukuu.org.uk> <20080722072334.GA25241@elte.hu> <48865899.3030209@garzik.org> <20080723104520.GA20672@elte.hu> <20080724052603.GA8744@elte.hu> <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk> <20080725203351.GA18407@us.ibm.com> <20080725142921.2238dc5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725142921.2238dc5a.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2008 [14:29:21 -0700], Andrew Morton wrote:
> On Fri, 25 Jul 2008 13:33:51 -0700
> Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> 
> > [resending with Linus' address fixed]
> > 
> > On 25.07.2008 [18:09:35 +0100], Alan Cox wrote:
> > > On Thu, 24 Jul 2008 07:26:03 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > not sure it's known but despite all the fixes i still get:
> > > > 
> > > >  drivers/built-in.o: In function `ne_drv_resume':
> > > >  ne.c:(.text+0x146ba4): undefined reference to `NS8390_init'
> > > >  drivers/built-in.o: In function `ne_block_output':
> > > >  ne.c:(.text+0x146e00): undefined reference to `NS8390_init'
> > > 
> > > This should do the trick. I can't test it currently as that configuration
> > > now fails to build with mm errors in current git head..
> > > 
> > > mm/hugetlb.c: In function ???hugetlb_acct_memory???: mm/hugetlb.c:1507:
> > > error: implicit declaration of function ???cpuset_mems_nr???
> 
> Remind me to give a wedgie to the next gcc developer I meet.

This may have been C&P error on my part, sorry about that.

> > When moving the intialization functions around, I did not remove the
> > dependency of some helpers on CONFIG_SYSCTL. This led to a large chunk
> > of code being elided even though it is needed to build hugetlb.o.
> > 
> > Fixes a build failure reported by Alan Cox:
> > 
> > mm/hugetlb.c: In function ______hugetlb_acct_memory______: mm/hugetlb.c:1507:
> > error: implicit declaration of function ______cpuset_mems_nr______
> 
> And the next one.
> 
> LANG=C stomps this silliness.

Yep, I've fixed the configuration of this box (I hope).

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
