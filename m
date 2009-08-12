Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbZHLJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbZHLJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbZHLJwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:52:20 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58291 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbZHLJwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:52:19 -0400
X-AuditID: b753bd60-a9670ba000004725-2e-4a8290d1498a
Message-ID: <4A8290CE.7000904@hitachi.com>
Date: Wed, 12 Aug 2009 18:52:14 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: tytso@mit.edu, hch@infradead.org, mfasheh@suse.com, aia21@cantab.net,
       hugh.dickins@tiscali.co.uk, swhiteho@redhat.com,
       akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for migration
    aware file systems
References: <200908051136.682859934@firstfloor.org> 
    <20090805093643.E0C00B15D8@basil.firstfloor.org> 
    <4A7FBFD1.2010208@hitachi.com> <20090810074421.GA6838@basil.fritz.box> 
    <4A80EAA3.7040107@hitachi.com> <20090811071756.GC14368@basil.fritz.box> 
    <4A822DD4.1050202@hitachi.com> <20090812074611.GC28848@basil.fritz.box>
In-Reply-To: <20090812074611.GC28848@basil.fritz.box>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>>Generally, dropping unwritten dirty page caches is considered to be
>>risky.  So the "panic on IO error" policy has been used as usual
>>practice for some systems.  I just suggested that we adopted
>>this policy into machine check errors. 
> 
> Hmm, what we could possibly do -- as followon patches -- would be to
> let error_remove_page check the per file system panic-on-io-error
> super block setting for dirty pages and panic in this case too.  
> Unfortunately this setting is currently per file system, not generic,
> so it would need to be a fs specific check (or the flag would need
> to be moved into a generic fs superblock field first)

A generic setting would be better, so I suggested
panic_on_dirty_page_cache_corruption flag which would be checked
before invoking error_remove_page().  If we check per-filesystem
settings, we might want to notify EIO to the filesystem.
 
> I think that would be relatively clean semantics wise. Would you be 
> interested in working on patches for that? 

Yes. :-)
I will work on this as soon as I come back from summer vacation.

>>Another option is to introduce "ignore all" policy instead of
>>panicking at the beginig of memory_failure().  Perhaps it finally
>>causes SRAR machine check, and then kernel will panic or a process
>>will be killed.  Anyway, this is a topic for the next stage.
> 
> The problem is memory_failure() would then need to start distingushing
> between AR=1 and AR=0 which it doesn't today.
> 
> It could be done, but would need some more work. 

It's my understanding that memory_failure() are never called in
AR=1 case.  Is it wrong?
 
Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

