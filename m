Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYH2Xgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYH2Xgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYH2Xgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:36:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:41611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYH2Xgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=veCU6fyYjkjrRIg5Ph6ojpjJZz+/PvwQ4qVbp5h+2zlDfEsGk9OPbeKJTMjj0fxs0J
         ojP/C+zvbxI5galvLlBBH0c0UpnTgJofXrboXy4x3FK1uIqtN5LxT+X+GmQNJsVa19qM
         vRLh4mJQ3eTP7XkB+gM3TIYQAjoLHdKvEHyRA=
Date: Sat, 30 Aug 2008 03:38:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON() should not use array type
Message-ID: <20080829233815.GA3365@x200.localdomain>
References: <48B7FDBA.76E4.0078.0@novell.com> <20080829132211.d0ed1932.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829132211.d0ed1932.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* Force a compilation error if condition is constant and true */
> > +#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
> 
> MAYBE_BUILD_BUG_ON() hurts my brain.  It's doing:
> 
> 	if (__builtin_constant_p(expr))
> 		BUILD_BUG_ON(expr);
> 
> yes?  For inlined (or macro) callsites which can be used with constant
> or non-constant args.
> 
> It's tempting to just zap the one callsite and not add this at all,

Yes, please. There should be no maybes in kernel.

Imagine probabilistic BUG_ON(). Imagine probabilistic refcounting: maybe_get_net().

