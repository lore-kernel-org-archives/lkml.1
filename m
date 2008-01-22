Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbYAVKFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbYAVKFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYAVKF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:05:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYAVKF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:05:28 -0500
Date: Tue, 22 Jan 2008 11:05:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080122100509.GC5722@elte.hu>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk> <20080120173938.GA27247@one.firstfloor.org> <47939787.3050707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47939787.3050707@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> I was thinking about this yesterday, and it seems to me that there are 
> two cleaner options here...
>
> - either we should put in the full machinery to be able to run C code 
> compiled with -fPIC/-fPIE before paging is enabled.  Unfortunately gcc 
> generates R_386_GOT32 relocations for external references even with 
> -fPIE, so we'll have to put in some code to adjust the GOT (easy 
> enough to do.)

i'd _love_ to have this approach instead of the assembly routines. While 
'constructing pagetables' might not look like a big deal in isolation - 
C is still 10 times more programmable than assembly. Pushing more of the 
early boot code into a sane, non-assembly environment will have positive 
long-term effects all across.

	Ingo
