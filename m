Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZHXUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZHXUg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZHXUgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZHXUgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:36:22 -0400
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify
 destruction
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       zdenek.kabelac@gmail.com, christoph.thielecke@gmx.de,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       grant.wilson@zen.co.uk, mikko.cal@gmail.com
In-Reply-To: <alpine.LFD.2.01.0908241220590.3158@localhost.localdomain>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
	 <200908242034.50885.elendil@planet.nl>
	 <1251140949.25096.16.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.LFD.2.01.0908241220590.3158@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 16:36:06 -0400
Message-Id: <1251146166.25096.22.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 12:23 -0700, Linus Torvalds wrote:
> 
> On Mon, 24 Aug 2009, Eric Paris wrote:
> > 
> > You suspect correctly.  :(  I'll fix in my tree before I request a
> > pull....
> 
> Can you change the WARN() to a WARN_ONCE() too. 
> 
> Generally, we prefer the "ONCE" variant if there isn't some intrisic 
> reason why we'd want to know about each event. If there is some load that 
> triggers this, do you care about _how_many_times_ it happens, or about the 
> fact that it happens in the first place? In this case, I think it's the 
> "happens in the first place" case - once you see it a single time, the 
> rest of the reports aren't that interesting.
> 
> And using the ONCE thing means that we know it's not going to spam the 
> logs.

If everyone having {fs,i}notify problems want to check out my latest
for-linus tree that would be great.  It has his latest tree plus fixed
'versions' of the 3 patches I sent earlier.

http://git.infradead.org/users/eparis/notify.git/shortlog/refs/heads/for-linus

-Eric

