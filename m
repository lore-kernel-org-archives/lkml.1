Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYCGHXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYCGHXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYCGHXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:23:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbYCGHXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:23:30 -0500
Date: Fri, 7 Mar 2008 08:23:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
Message-ID: <20080307072304.GA25351@elte.hu>
References: <20080307034155.A8C6EDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307034155.A8C6EDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


[Cc:-ed FUJITA Tomonori who did the Alpha IOMMU changes - full report 
from Bob quoted below.]

Bob, does latest -git boot if you revert these 4 commits:

commit d5a4630a0daad241c761064295958554472ed491
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Mar 4 14:28:58 2008 -0800

    alpha: remove unused DEBUG_FORCEDAC define in IOMMU

commit cf5401454863df8e6dc3ebe8faad09141cbec187
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Mar 4 14:28:57 2008 -0800

    alpha: make IOMMU respect the segment boundary limits

commit 23d7e0390ab57cf15a5cfe8d6806192f0997e5a8
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Mar 4 14:28:57 2008 -0800

    alpha: IOMMU had better access to the free space bitmap at only one place

commit 3c5f1def7dd50b792f56dcf7378c2684c06947f3
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Mar 4 14:28:54 2008 -0800

    alpha: convert IOMMU to use ALIGN()

	Ingo

* Bob Tracy <rct@frus.com> wrote:

> The regression is relative to 2.6.25-rc1 + timer fixes (added when
> I reported the problems with 2.6.25-rc1 relative to 2.6.24).  I haven't
> tried -rc2 or -rc3.
> 
> Might be related to similar reports I've seen, but wanted to add the
> Alpha platform to the list.  The -rc4 kernel boots, but at some point
> following initialization of the SCSI layer, there's a panic with enough
> diagnostic output that a 50-line screen can't hold it all.  Unfortunately,
> the system logging isn't active, so nothing gets captured.
> 
> The panic is completely reproducible.  The "Code" line at the bottom
> of the panic output is
> 
> 44220001 4821f621 4821b681 4821f62b f420004f 00000081 <0000009b> 0066c012
> 
> The first line of the "Trace" section is
> 
>  [<fffffc000031a41f>] iommu_arena_alloc+0x64/0xe0
> 
> Platform is an Alpha PWS 433au.  gcc is version 4.1.2 (Debian 4.1.1-21).
> 
> -- 
> ------------------------------------------------------------------------
> Bob Tracy          |  "I was a beta tester for dirt.  They never did
> rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
> ------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
