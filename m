Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbZC0VEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbZC0VEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbZC0VEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:04:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46596 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409AbZC0VEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:04:22 -0400
Date: Fri, 27 Mar 2009 22:05:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Anholt <eric@anholt.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: DRM lock ordering fix series
Message-ID: <20090327210534.GD11935@one.firstfloor.org>
References: <1238017510-26784-1-git-send-email-eric@anholt.net> <87ocvnmhqx.fsf@basil.nowhere.org> <1238170767.8275.2397.camel@gaiman.anholt.net> <1238171805.8275.2434.camel@gaiman.anholt.net> <20090327181018.GC11935@one.firstfloor.org> <1238184629.625.44.camel@gaiman.anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238184629.625.44.camel@gaiman.anholt.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK.  I'm not too excited here -- 10% of 2% of the CPU time doesn't get
> me to the 10% loss that the slow path added up to.  Most of the cost is
> in k{un,}map_atomic of the returned pages.  If the gup somehow filled in
> the user's PTEs, I'd be happy and always use that (since then I'd have

On x86 the user PTEs are already there if it's your current process
context so you could just use them. And it's even safe to use as long as its 
locked.  But that would be a x86 specific hack, not working on all platforms 
that have split kernel user address spaces (that includes UML)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
