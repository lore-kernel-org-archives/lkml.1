Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZDWVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZDWVdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbZDWVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:33:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbZDWVdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:33:05 -0400
Date: Thu, 23 Apr 2009 23:32:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5 -tip] umount_begin BKL pushdown
Message-ID: <20090423213249.GA4814@elte.hu>
References: <1240513925-5603-1-git-send-email-abogani@texware.it> <20090423191817.GW8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423191817.GW8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Apr 23, 2009 at 09:12:00PM +0200, Alessio Igor Bogani wrote:
> > Push the BKL acquisition from vfs to every specific filesystems
> > with hope that it can be eliminated in a second moment.
> > 
> > The first 4 patches add BKL lock into umount_begin() functions 
> > (for the filesystems that have this handler). The last one 
> > remove lock_kernel()/unlock_kernel() from fs/namespace.c (the 
> > only point that invoke umount_begin() funtcions).
> 
> I'd rather collapse all these patches together; no point doing 
> that per-fs (for all 4 of them).  And CIFS side is bogus.
> 
> Another thing: -tip is no place for that.  I can put that into VFS 
> tree, provided that comments above are dealt with.

When that happens, could you please put it into a separate, 
append-only branch i could pull (after some initial test-time) into 
tip:kill-the-BKL?

Thanks,

	Ingo
