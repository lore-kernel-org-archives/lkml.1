Return-Path: <linux-kernel-owner+w=401wt.eu-S935636AbYD1UPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935636AbYD1UPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbYD1UPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:15:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbYD1UPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:15:20 -0400
Date: Mon, 28 Apr 2008 22:15:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to
	discrete layout v3
Message-ID: <20080428201506.GE15840@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804280206.52641.yhlu.kernel@gmail.com> <200804281244.56938.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804281244.56938.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> some BIOS like to use continus MTRR layout, and some X driver can not 
> add WB entries for graphical cards when 4g or more RAM installed.
> 
> the patch will change MTRR to discrete.
> 
> mtrr_chunk_size= could be used to have smaller continuous block to 
> hold holes. default is 256m, could be set according to size of 
> graphics card memory.
> 
> v2: fix -1 for UC checking

> v3: default to disable, and need use enable_mtrr_cleanup to enable 
>     this feature
>     skip the var state change warning.
>     remove next_basek in range_to_mtrr()

a boot option is often inconvenient though - could you perhaps also make 
this a Kconfig option, with it defaulting to off? Something like 
CONFIG_MTRR_SANITIZE=y or so? That way distros can make a conscious 
decision as well whether they want this feature (for the Xorg they pick) 
or not.

	Ingo
