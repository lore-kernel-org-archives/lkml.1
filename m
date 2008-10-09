Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYJIJ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYJIJ6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYJIJ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:58:26 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:46016 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbYJIJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:58:25 -0400
Subject: Re: [PATCH] documentation: explain memory barriers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
In-Reply-To: <48ED9BFB.4060904@redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
	 <20081001225404.4e973465.akpm@linux-foundation.org>
	 <20081008181223.6954c7b2.randy.dunlap@oracle.com>
	 <48ED5BC6.8040006@redhat.com>
	 <20081008183125.2a24e3c2.akpm@linux-foundation.org>
	 <48ED9BFB.4060904@redhat.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Thu, 09 Oct 2008 10:58:18 +0100
Message-Id: <1223546298.3984.100.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 01:51 -0400, Chris Snook wrote:
> Andrew Morton wrote:
> > On Wed, 08 Oct 2008 21:17:58 -0400 Chris Snook <csnook@redhat.com> wrote:
> > 
> >> Randy Dunlap wrote:
> >>> On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:
> >>>
> >>>> This sequence is repeated three or four times and should be pulled out
> >>>> into a well-commented function.  That comment should explain the logic
> >>>> behind the use of these barriers, please.
> >>> and on 2008-OCT-08 Ben Hutchings wrote:
> >>>
> >>>> All memory barriers need a comment to explain why and what they're doing.
> > 
> > I approve this message.
> > 
> >> Seriously?  When a barrier is used, it's generally self-evident what 
> >> it's doing.
> > 
> > fs/buffer.c:sync_buffer().  Have fun.
> 
> The real disaster there is the clear_buffer_##name macro and friends, as
> evidenced by fs/ext2/inode.c:599
> 
>                 clear_buffer_new(bh_result); /* What's this do? */
> 
> I'm completely in favor of documenting everything that can potentially interact
> with that train wreck, but I maintain that the vast majority of memory barriers
> are self-evident.

Acquire and release barriers attached to operations are usually self-
evident; standalone wmb() and rmb() much less so.  It is helpful to be
explicit about exactly which memory operations need to be ordered, which
are often not the memory operations immediately preceding and following
it.  "all" may have been a bit strong though.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

