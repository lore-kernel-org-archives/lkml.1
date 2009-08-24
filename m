Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZHXTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZHXTcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZHXTcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZHXTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:32:42 -0400
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
Date: Mon, 24 Aug 2009 15:32:31 -0400
Message-Id: <1251142351.25096.17.camel@dhcp231-106.rdu.redhat.com>
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

Fixed.

