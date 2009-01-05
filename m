Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZAEM3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZAEM3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZAEM2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:28:45 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43801 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753911AbZAEM2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:28:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q0PpZAneXBR7UwMQ0dLWUaRe29OkIVT7I9WvpmtAa117BrNPFyYYDY0+ichoPFn8qcrF3W9c5VfQsRIUTabZMn9W8xKMJf2HXp8iDDfe0n+WMPNKYCvFlvojEo0C31FvwFfQAPJ95kjd6c/m/ZMWFT3Iig0H64r8zA2FHdSedHE=  ;
X-YMail-OSG: QmPyIWQVM1ljRkDZK_CzE8SuJxbDOUbNHBH3wYjh6fcZyp0uboFsKxrj2eLx0gHVhfyetcaQqFzWmYkqfnA4ct2jDKveQ8vKLebpb31AOgQ9JuGegCun5iWbYH_oh05yoyyv6GAiTBkSMCOBqWIk1pwkvydRzjb0A6oVnM_f9jjXEUPHvWJODLPBifzdGUQA2OAhU4Ek979wXk4PiPHvMHv12U5xW5vk
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Date: Mon, 5 Jan 2009 23:28:26 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052328.26630.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 19:43:00 Andrew Morton wrote:
> The individual patches are mostly at
> http://userweb.kernel.org/~akpm/mmotm/broken-out/
>
>
> mm-remove-the-might_sleep-from-lock_page.patch
>
>   Need to think about this.

Removing this reduces a lot of might_sleep coverage scope. Page
lock isn't contended in a lot of cases. Why would you drop a
good debugging feature?

> mm-direct-io-starvation-improvement.patch
> fs-remove-wb_sync_hold.patch
> fs-sync_sb_inodes-fix.patch
> fs-sys_sync-fix.patch
> radix-tree-gang-set-if-tagged-operation.patch

This one is unneeded because you didn't take the fsync livelock avoidance
patch that makes use of the new function.

> make-sure-nobodys-leaking-resources.patch
> releasing-resources-with-children.patch

Any reason why not to add these upstream?

> nr_blockdev_pages-in_interrupt-warning.patch

Lockdep should catch this, I guess.

> put_bh-debug.patch

This could just be implemented with a VM_BUG_ON (or FS_BUG_ON) like the
pagecache refcounting. Wouldn't be a bad idea.

> add-a-refcount-check-in-dput.patch

Again, why not an FS_BUG_ON for things like this too?

