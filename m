Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYC0JrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYC0JrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYC0JrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:47:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbYC0JrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:47:12 -0400
Date: Thu, 27 Mar 2008 10:46:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
	setup_data to boot protocol
Message-ID: <20080327094648.GA5056@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com> <20080327083221.GD15626@elte.hu> <20080327040216.99dcde7b.pj@sgi.com> <20080327090925.GC30918@elte.hu> <20080327042147.15f7ce28.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327042147.15f7ce28.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> Ingo wrote:
> > stupidly shortsighted limit ...
> 
> Eh ... I don't think all that shortsighted ... that 4096 limit has 
> probably been around longer than Linux.  Linus or hpa or others would 
> know the history better than I do.

the limit for boot parameters is 2048 bytes - the BUILD_WARN_ON() checks 
for the sum of the two boot parameter areas. We used empty_zero_page for 
boot parameter passing for a near eternity - 2K for the command line 
(which used to be clipped - recently upped to true 2048), and 2K for the 
boot parameters.

As a historic/nostalgic sidenote: the 2048 limit is not as old as Linux, 
version 0.11 of Linux had 512 bytes of special area for boot parameters, 
at 0x90000-0x901FF.

having fixed-length 2K buffering ABI between two historically rather 
inflexible pieces of software (the bootloader and the kernel), at a very 
fragile and under-capable junction of our bootstrap (very early during 
bootup) _is_ shortsighted. Granted, it's a difficult area to change but 
still it's a nasty limit - as you have found it out first-hand ;-)

	Ingo
