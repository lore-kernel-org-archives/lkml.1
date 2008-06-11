Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYFKUac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYFKUac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYFKU1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:27:39 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:43841 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbYFKU1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:27:37 -0400
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080611130145.2a202339.akpm@linux-foundation.org>
References: <20080611184214.605110868@redhat.com>
	 <20080611184339.493423475@redhat.com>
	 <20080611130145.2a202339.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 11 Jun 2008 16:28:03 -0400
Message-Id: <1213216083.6436.66.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 13:01 -0700, Andrew Morton wrote:
> On Wed, 11 Jun 2008 14:42:25 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > Define proper false/noop inline functions for noreclaim page
> > flags when !defined(CONFIG_NORECLAIM_LRU)
> 
> I changed that to CONFIG_UNEVICTABLE_LRU.

I noticed that the vmstat items [perhaps these will go away] still use
"noreclaim".

> 
> Did we agree that the presence of this config variable is undesirable? 

Not sure we did.  It does add quite a bit of code that probably wouldn't
be needed/wanted for, say, a laptop system or other small systems that
still have an mmu.  I initially made it configurable keeping in mind
your speeches about not burdening smaller systems with larger system
features, ...  

> If so, what's involved in making it go away?

Just some busy work.  I added a fair number of wrappers and such to
minimize #ifdefs in the .c files.  This resulted in quite a few such
#ifdefs in the respective headers.   Removing these should mostly
involve removing the #ifdef and the #else case.  Most of them that
remain in .c files are for large blocks of code, mostly complete
functions, and can just be removed.

Let me know the consensus.  I can send in a patch to remove them if it's
agreed.  Might want to wait until we're sure that this is the only
barrier to merging, as the option might be useful during testing. 

Lee


