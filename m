Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYCDG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYCDG7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYCDG7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:59:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbYCDG7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:59:12 -0500
Date: Tue, 4 Mar 2008 07:58:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, hans.rosenfeld@amd.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080304065853.GB32287@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org>
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


* Segher Boessenkool <segher@kernel.crashing.org> wrote:

> so (on 32-bit) ~_PAGE_PSE is ~0x80L is 0xffffff7f, which when cast to 
> 64-bit is 0x00000000ffffff7f, so in
>
> 	(~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)
>
> all the high bits are lost, while the original
>
> 	~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)
>
> works as intended, since the bit inversion is done on a 64-bit number.

but we really are interested in the low bits here (lets ignore the NX 
bit for now) and the patch has been in the queue for a long time (more 
than a month), so if there was a trivial mask mixup problem it would 
have shown on the first day. So i suspect some gcc bug instead - and 
certainly the colorful mixture of types and signs in this expression 
might have surprised a new version of gcc somewhere.

	Ingo
