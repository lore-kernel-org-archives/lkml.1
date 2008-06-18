Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbYFRHwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbYFRHwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYFRHv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:51:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYFRHv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:51:56 -0400
Date: Wed, 18 Jun 2008 09:51:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Glauber Costa <glommer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Message-ID: <20080618075137.GC4135@elte.hu>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-2-git-send-email-robert.richter@amd.com> <5d6222a80806131002t4f5c6e54tee63d4ed0fc222a6@mail.gmail.com> <20080613181627.GH10019@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613181627.GH10019@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ok, so what about shared code? Keep all this in separate files: 
> amd_bus.c, (amd_bus_32.c), amd_bus_64.c, (amd_bus.h)?
> 
> Is the strategy to avoid #ifdefs and instead use the flags in 
> Makefiles? My intention was to coalesce the files. Maybe I was wrong 
> here.

What you did is fine - first step is to move the variants as close to 
each other as possible, in an as obvious and mechanic step as possible.

If anything breaks due to your patches then they were probably too 
large, but lets be optimistic and try your current splitup first :)

Then we can start eliminating any leftover #ifdefs, step by step. Please 
send very, very small patches for that (put them into a git tree on 
kernel.org if there's more than say a dozen of them), we'll test them, 
and if the changes break anything it's all bisectable to an individual 
change.

	Ingo
