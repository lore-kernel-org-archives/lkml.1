Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZDNQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZDNQ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbZDNQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:57:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49801 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZDNQ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=In5H4OapI0plgKgbJJEjO78HpahM9y9qVeOOI3m4bArrA9EYp8wvgPyjUosjfAJcz4
         p/szuJRM10iC1CmmOqY9mNQbgAioiwzR83OKG5iWrDsFRYG8KOglj/7jiBTO5K8CeB3H
         2JzlR/wgaSGxr0+LqdJ3JsuDSod2AnOmWsTmQ=
Date: Tue, 14 Apr 2009 20:57:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414165734.GB27923@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain> <1239723694.32604.62.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239723694.32604.62.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 08:41:34AM -0700, Dave Hansen wrote:
> On Tue, 2009-04-14 at 19:27 +0400, Alexey Dobriyan wrote:
> > > Also, since Dave introduced the fops->checkpoint(), we (or at least I)
> > > have been struck by the ugly assymetry with checkpoint() being in fops,
> > > and restart() not.  Do you have an idea for fixing that?
> > 
> > Module can legally support C/R for its files.
> > 
> > In the end it most certainly will end up with module registering restart
> > hook for file type N.
> > 
> > Or module registering hook to restart object type N.
> 
> Yeah, that was my expectation as well.  There's a point when we just
> have too many kinds of checkpoint objects and the switch statements get
> out of hand.  Oversimplified, of course, but:
> 
> 	init_restart_handler(CR_FD_GENERIC, restore_generic_fd);
> 	init_restart_handler(CR_FD_SOCKET, restore_socket);
> 	init_restart_handler(CR_FD_PIPE, restore_pipe);
> 
> The only question to me is whether we allow the handler functions to do
> further reading of the checkpoint image or whether the higher-level code
> should be feeding them all the data they'll need in some way.

It depends, but since you don't know what it's in dumped state, it's
better to leave freedom for restart hook.

It gets restart context as cookie, position of start of an object, and
exported functions cr_read/cr_pread/whatever which accept cooked
context.
