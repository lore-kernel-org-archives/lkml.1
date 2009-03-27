Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZC0SJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZC0SJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZC0SJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:09:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZC0SJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:09:05 -0400
Date: Fri, 27 Mar 2009 19:10:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Anholt <eric@anholt.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: DRM lock ordering fix series
Message-ID: <20090327181018.GC11935@one.firstfloor.org>
References: <1238017510-26784-1-git-send-email-eric@anholt.net> <87ocvnmhqx.fsf@basil.nowhere.org> <1238170767.8275.2397.camel@gaiman.anholt.net> <1238171805.8275.2434.camel@gaiman.anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238171805.8275.2434.camel@gaiman.anholt.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 09:36:45AM -0700, Eric Anholt wrote:
> > > You are aware that there is a fast path now (get_user_pages_fast) which
> > > is significantly faster? (but has some limitations)
> > 
> > In the code I have, get_user_pages_fast is just a wrapper that calls the
> > get_user_pages in the way that I'm calling it from the DRM.
> 
> Ah, I see: that's a weak stub, and there is a real implementation.  I
> didn't know we could do weak stubs.

The main limitation is that it only works for your current process,
not another one. For more details you can check the git changelog
that added it (8174c430e445a93016ef18f717fe570214fa38bf)

And yes it's only faster for architectures that support it, that's
currently x86 and ppc.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
