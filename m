Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZDMHLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZDMHLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZDMHLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:11:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40075 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZDMHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nG96uCVjLhOw/UMcCGG1ShU9ap0FYwUAPEF0PqUhpq0n7XIZJEPi8T7o4kCJIES8Z9
         QmG9iqt1l5KI9Po+fSO05VGwLMJltbQaD30RFRwO7kVzFlSplrJ4BvtBAH0FfZiRSnF0
         6rMNGS4VlIwHb56xGnAT/tX/+fzKMUHyx/o1I=
Date: Mon, 13 Apr 2009 11:11:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/30] netns: extract net_create()
Message-ID: <20090413071111.GA7085@x200.localdomain>
References: <20090410023448.GH27788@x200.localdomain> <20090410225636.GD13873@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410225636.GD13873@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 05:56:36PM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > net_create() will be used by C/R code to create fresh netns on restart.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> Although this ends up making a new assumption that setup_net(), and
> therefore the pernet_ops->init() functions, do not return error > 0.
> There's nothing actually stopping that (outside of code review, but
> there appears to be no comment anywhere saying that's uncooth).
> 
> If it returns > 0, then we return the ns as though it were valid, but
> don't add it to the list of namespaces...  Do we care?

I think, no.

Recalling all the code put under netns changes, ->init hooks were put
under 0/-E convention. For sure, my changes in netns xtables,
conntracking and xfrm were definitely under it.

> > -struct net *copy_net_ns(unsigned long flags, struct net *old_net)
> > +struct net *net_create(void)
