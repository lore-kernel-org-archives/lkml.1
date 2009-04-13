Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZDMHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZDMHj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZDMHjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:39:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11947 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZDMHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jGhpxCxXGJqdXIYAAKen5cBlRzxUFKYp3BvelIbD3NaiGd+H8GnGBC1tWuIw4zRilu
         wuNgy272S+rh7vOC7AT0i2zHeM4Am/NWvXpJ7WNRlD+zvWzGBLwhmkoqmBdF70wq7v3c
         Mrh188Lc3/jwKhFRdHpBeRVHI33CS+v8hBRaE=
Date: Mon, 13 Apr 2009 11:39:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090413073925.GB7085@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 08:06:55AM -0700, Linus Torvalds wrote:
> On Fri, 10 Apr 2009, Alexey Dobriyan wrote:
> >
> > This is to show how we see C/R and to provoke discussion on number of
> > important issues (mounts, ...).
> 
> My only initial reaction is that I absolutely hate the naming (not to say 
> I love the code - just to say that I didn't even look at it, because I got 
> hung up on the name).
> 
> "cr"? It could be anything. I realize that to _you_ that is meaningful, 
> but to somebody less specifically interested in checkpoint-restore 'cr' 
> means 'carriage return' or just doesn't really say anything at all. 

Well, in OpenVZ everything is in kernel/cpt/ and prefixed with "cpt_"
and "rst_". And I think "cr_" is super nice prefix: it's short, it's C-like,
it reminds about restart part. Eventually, C/R will become standard
in-kernel thing everyone should be at least aware of, so it's like
learning what "vma" means.

> That goes both for file naming (kernel/cr/xyzzy.c) and to a lesser degree 
> for function naming too. I also don't think it makes sense to have 
> something like kernel/cr/cr-x86_32.c or kernel/cr/cr-tty.c - maybe that is 
> good right now, but I sure hope that the long-term goal is to have these 
> things in the code that will need to change them when the code gets 
> updated (ie arch/x86/kernel and drivers/char/)

In the long run, yes, C/R should be moved closer to core code it tries to
checkpoint. Right now, however, doing "make kernel/cr/" is much quicker
and C/R can not do much, so it's unclear how exactly splitting should be
done.
