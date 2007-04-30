Return-Path: <linux-kernel-owner+w=401wt.eu-S1423514AbXD3SVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423514AbXD3SVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423507AbXD3SVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:21:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423514AbXD3SVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:21:46 -0400
Date: Mon, 30 Apr 2007 11:21:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
Message-Id: <20070430112130.b64321d3.akpm@linux-foundation.org>
In-Reply-To: <4636248E.7030309@imap.cc>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46338AEB.2070109@imap.cc>
	<20070428141024.887342bd.akpm@linux-foundation.org>
	<4636248E.7030309@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 19:17:02 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> >> With kernel 2.6.21-rc7-mm2, my Dell Optiplex GX110 (P3/933) regularly
> >> crashes during the SuSE 10.1 startup sequence. When booting to RL5,
> >> it panicblinks shortly after the graphical login screen appears.
> >> Booting to RL3, it hangs after the startup message:
> 
> I have now bisected this down to the section in the series file between
> #GREGKH-DRIVER-START and #GREGKH-DRIVER-END, and therefore added GregKH
> to the CC list.

This is rather good news.  I was staring at about 200-300 MM patches
wondering which one was buggy.  Thanks heaps for doing the bisect.  Now the
main worry is Randy's dead box.

A lot of Greg's driver tree has gone upstream, so please check current
mainline.  If that's OK then we need to pick through the difference between
2.6.21-rc7-mm2's driver tree and the patches which went into mainline.  And
that's a pretty small set.

> I'll try bisecting further inside that section (unless
> you tell me not to), but it may take some time.
> 
> The exact point during the startup sequence when the crash occurred and
> the amount of BUG messages produced varied somewhat during these tests.
> The common denominator, and my criterion for the good/bad decisions
> during the bisect, was the crash (panic blink) just before completion
> of the system startup.
> Sometimes there weren't any BUG messages in the log (or perhaps they
> just didn't make it to the disk.) Sometimes I just had a couple of the
> "sleeping function called from invalid context at mm/slab.c:3054"
> ones but no "Eeek! page_mapcount(page) went negative!" one before them.
> However, whenever the "Eeek!" did appear it announced "getcfg-interfac"
> as the current process and was followed by a few of the "mm/slab.c:3054"
> ones.

hm, big mess.  Could be it was some glitch from Tejun's sysfs changes which
are all being extensively redone, so perhaps we'll never hear from it
again.  Or perhaps we just merged it into mainline.
