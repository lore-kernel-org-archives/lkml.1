Return-Path: <linux-kernel-owner+w=401wt.eu-S932551AbYBMJXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbYBMJXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbYBMJWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:22:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbYBMJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:22:26 -0500
Date: Wed, 13 Feb 2008 10:22:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
Message-ID: <20080213092208.GC21614@elte.hu>
References: <20080213052903.B1F1CDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213052903.B1F1CDBA2@gherkin.frus.com>
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


* Bob Tracy <rct@frus.com> wrote:

> This isn't going to be terribly useful other than giving someone a 
> heads-up there's a problem with something in 2.6.25-rc1 on the Alpha 
> PWS 433au.  I get the usual messages out of "aboot", including
> 
> aboot: zero-filling 210392 bytes at 0xfffffc0000776740 aboot: starting 
> kernel vmlinux.new.gz with argument ro root=/dev/sda3
> 
> and then the screen background switches to red and the machine locks 
> up solid.  No further console output.  Completely reproducible.  The 
> 2.6.24 kernel is fine.
> 
> Unless someone has a good idea what's causing this, I see a massive 
> "git bisect" project in my future.  Won't be able to spend any time 
> with this until at least the weekend :-(.

hm, is this SMP? Alpha uses asm-generic/percpu.h. One "early bootup" 
effect on Alpha that i can think of could have been this family of 
commits:

 commit acdac87202a408133ee8f7985076de9d2e0dc5ab
 Author: travis@sgi.com <travis@sgi.com>
 Date:   Wed Jan 30 13:32:52 2008 +0100

     percpu: make the asm-generic/percpu.h more "generic"

you wont be able to revert this patch cleanly, perhaps try to compile 
commit cf8fa920cb4271f17e0265c863d64bea1b31941a and see whether it 
boots. (that tree does not have the percpu changes yet)

if that doesnt help then i guess it's the bisection of 9000+ commits :-/

	Ingo
