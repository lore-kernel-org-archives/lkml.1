Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbZHLKRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbZHLKRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZHLKRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:17:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52643 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZHLKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:17:00 -0400
Date: Wed, 12 Aug 2009 12:16:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, tytso@mit.edu, hch@infradead.org,
       mfasheh@suse.com, aia21@cantab.net, hugh.dickins@tiscali.co.uk,
       swhiteho@redhat.com, akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for
	migration aware file systems
Message-ID: <20090812101658.GF28848@basil.fritz.box>
References: <200908051136.682859934@firstfloor.org> <20090805093643.E0C00B15D8@basil.firstfloor.org> <4A7FBFD1.2010208@hitachi.com> <20090810074421.GA6838@basil.fritz.box> <4A80EAA3.7040107@hitachi.com> <20090811071756.GC14368@basil.fritz.box> <4A822DD4.1050202@hitachi.com> <20090812074611.GC28848@basil.fritz.box> <4A8290CE.7000904@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8290CE.7000904@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 06:52:14PM +0900, Hidehiro Kawai wrote:
> Andi Kleen wrote:
> 
> >>Generally, dropping unwritten dirty page caches is considered to be
> >>risky.  So the "panic on IO error" policy has been used as usual
> >>practice for some systems.  I just suggested that we adopted
> >>this policy into machine check errors. 
> > 
> > Hmm, what we could possibly do -- as followon patches -- would be to
> > let error_remove_page check the per file system panic-on-io-error
> > super block setting for dirty pages and panic in this case too.  
> > Unfortunately this setting is currently per file system, not generic,
> > so it would need to be a fs specific check (or the flag would need
> > to be moved into a generic fs superblock field first)
> 
> A generic setting would be better, so I suggested
> panic_on_dirty_page_cache_corruption flag which would be checked
> before invoking error_remove_page().  If we check per-filesystem
> settings, we might want to notify EIO to the filesystem.

You mean remounting ro if that is set?
That makes sense, but I'm not sure how complicated it would be.
I still would prefer to unify it with the file system settings.

> > The problem is memory_failure() would then need to start distingushing
> > between AR=1 and AR=0 which it doesn't today.
> > 
> > It could be done, but would need some more work. 
> 
> It's my understanding that memory_failure() are never called in
> AR=1 case.  Is it wrong?

Today yes, but we don't want to hardcode that assumption. e.g. for IA64
they will definitely need the equivalent of AR=1 handling.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
