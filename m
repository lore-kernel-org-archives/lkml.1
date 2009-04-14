Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZDNREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZDNREU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDNREK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:04:10 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44093 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZDNREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnObcJxzZH1dQrDbohbUotOBFt5l0qcfQX1EUs5WIDcn7mj8jPGMjXlInjnIhd5jzP
         GIF2rd5+8d60/qEoChIpvR4rKsBYIeJBF5F6V2UUW+Ibi1eThLneVG8m4Xay7XMwZl3+
         4tL5NLl3njKGXZn6JQJ6vj+XFvNrdrKfTJ5VA=
Date: Tue, 14 Apr 2009 21:04:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414170419.GD27923@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain> <20090414154139.GA8085@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414154139.GA8085@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:41:39AM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > On Mon, Apr 13, 2009 at 04:47:01PM -0500, Serge E. Hallyn wrote:
> > > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > 
> > > Hi Alexey,
> > > 
> > > as far as I can see, the main differences between this patch and the
> > > equivalent in Oren's tree are:
> > > 
> > > 1. kernel auto-selects container init to freeze
> > 
> > Note, auto-select part was dropped, userspace is required to pass pid of
> > container init exactly. This was done to keep semantic of checkpoint(2)
> > small and extendable.
> 
> sys_checkpoint() in this patch still finds the child_reaper of the
> passed-in pid, doesn't it?  Or are you saying that a later patch in
> this set removes that?
> 
> > > 2. kernel freezes tasks
> > > 3. no objhash taking references
> > 
> > That's because none needed.
> 
> Right while I have opinions on some things in this list, I didn't
> mean to imply positions on these items.  My question was:  are
> there are differences you want to call out?

Sorry? "none needed" is relevant to only item 3. If tasks don't
dissapear during checkpoint, why would netns dissapear.
Taking refcount on checkpoint(2) is likely unneeded.

But it's low-level detail anyway.
