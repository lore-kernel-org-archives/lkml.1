Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYAaJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYAaJwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYAaJwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:52:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60527 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbYAaJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:52:40 -0500
Date: Thu, 31 Jan 2008 10:52:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: about relocs.c on x86
Message-ID: <20080131095223.GA11867@elte.hu>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> why not rename relocs.c to relocs_32.c?
> 
> it is only used for 32 bit, even it is host app.

during the big first phase of unification we generally kept file names 
untouched if they were only present in one of the previous 
architectures. I.e. pure 32-bit and pure 64-bit files were not renamed 
to _32/_64.

Now that we've got lots of unified 32/64-bit files it might make sense 
to rename the 'standalone' ones into _32/_64 if they share the same 
directory with 32/64-bit source files - to reduce the confusion. And 
given that for example arch/x86/boot/compressed/misc.c is unified while 
arch/x86/boot/compressed/relocs.c is 32-bit only, i'd agree with your 
observation. Feel free to send a rename patch for such cases.

	Ingo
