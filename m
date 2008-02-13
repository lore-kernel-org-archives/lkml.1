Return-Path: <linux-kernel-owner+w=401wt.eu-S1765026AbYBMLS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765026AbYBMLS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYBMLSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:18:20 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40524 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbYBMLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:18:19 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080213061653.GA10784@kroah.com>
References: <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <20080212.155853.193190548.davem@davemloft.net>
	 <20080213002948.GA8899@kroah.com>
	 <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
	 <20080213061653.GA10784@kroah.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 13 Feb 2008 10:48:33 +0000
Message-Id: <1202899713.21202.10.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2008 10:48:29.0691 (UTC) FILETIME=[F835ACB0:01C86E2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 22:16 -0800, Greg KH wrote:
> Ted's description matches mine (keep quilt tree in git, edit changelog
> entries, rebase on newer kernel versions, etc.)  I can go into details
> if needed.

I added some time ago patch history tracking in stgit and you can run
"stg log [--graphical] <patch>" to see all the changes for that patch
(as a list or via gitk). This is done by keeping a separate DAG of
commits linking small changes to a patch.

> I was amazed at how slow stgit was when I tried it out.  I use
> git-quiltimport a lot and I don't think it's any slower than just using
> quilt on its own.  So I think that the speed issue should be the same.

It shouldn't be slower than git-quiltimport (at least the recent stgit
versions) as they seem to have a similar approach (using "git apply").
There is probably an extra check stgit does for local changes before
starting the import. Otherwise, just use git-quiltimport and "stg
uncommit" to generate the patches.

StGIT approach for pushing patches is to use git-apply and, only if this
fails, switch to a three-way merge. These days it seems that the
three-way merge is pretty fast anyway, we might drop the former (after
some benchmarking).

> I had a number of issues last time I tried stgit out, but maybe they are
> now resolved, I'll try it out tomorrow and report to the git list
> anything I find that doesn't work for me.

Please try the last stable release, 0.14. The current HEAD has some
restructuring done (but gets nice features like transactions, undo).

Thanks.

-- 
Catalin

