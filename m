Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbZLPAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbZLPAx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbZLPAxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:53:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54450 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbZLPAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:53:14 -0500
Date: Wed, 16 Dec 2009 01:53:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091216005308.GB3622@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org> <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box> <1260921277.3219.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260921277.3219.18.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want to work around the problem rather than going for something

I am mostly interested in making the ugly warning on my systems
go away, preferably without breaking anything in the process.
Whatever works.

> like Peter's split up of the mmap() callback, then I'd suggest changing
> to using nfs_revalidate_mapping_nolock() instead. The fact that we are
> seeing these lock misordering warnings is proof that the call to
> nfs_revalidate_mapping() is not always a no-op.

I would say the interesting question is if there is really a expectation
that mmap does this kind of synchronization? 

Why in mmap, not somewhere else?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
