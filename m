Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYEGFUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYEGFUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYEGFUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:20:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:6386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbYEGFUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:20:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="380821819"
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
From: "Huang, Ying" <ying.huang@intel.com>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208403403.4322.27.camel@caritas-dev.intel.com>
	 <20080423223221.GB16683@Chamillionaire.breakpoint.cc>
	 <1209093077.20936.24.camel@caritas-dev.intel.com>
	 <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 May 2008 13:26:13 +0800
Message-Id: <1210137973.4676.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 07 May 2008 05:20:27.0483 (UTC) FILETIME=[0F6612B0:01C8B002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sebastian,

On Wed, 2008-04-30 at 00:12 +0200, Sebastian Siewior wrote:
> * Huang, Ying | 2008-04-25 11:11:17 [+0800]:
> 
> >Hi, Sebastian,
> Hi Huang,
> 
> sorry for the delay.
> 
> >I changed the patches to group the read or write together instead of
> >interleaving. Can you help me to test these new patches? The new patches
> >is attached with the mail.
> The new results are attached.

It seems that the performance degradation between step4 to step5 is
decreased. But the overall performance degradation between step0 to
step7 is still about 5%.

I also test the patches on Pentium 4 CPUs, and the performance decreased
too. So I think this optimization is CPU micro-architecture dependent.

While the dependency between instructions are reduced, more registers
(at most 3) are saved/restored before/after encryption/decryption. If
the CPU has no extra execution unit for newly independent instructions
but more registers are saved/restored, the performance will decrease.

We maybe should select different implementation based on
micro-architecture.

Best Regards,
Huang Ying

