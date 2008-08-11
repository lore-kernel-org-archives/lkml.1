Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYHKSt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYHKSt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYHKSts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:49:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYHKSts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:49:48 -0400
Date: Mon, 11 Aug 2008 20:49:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811184903.GB12788@elte.hu>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl> <20080811183300.GB9627@elte.hu> <20080811184257.GB18969@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811184257.GB18969@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> |   early_param conversions - and i think highlighting that as 
> |   separate commits might give someone ideas to improve the 
> |   early_param() facility, if they see the fix patterns.
> 
> Ingo - I think the problem with early_param is not NULL itself but 
> rather - what is the right way to deal with boot params? I mean we 
> could pass empty string (not NULL) in case of argument absence _but_ 
> would it be the right way? If you remember when I sent first series 
> for early_param checking (and actually there are number of same issue 
> exists for example in s390 arch) - I was asking community what is the 
> best way - since I'm not that strong in interface engineering - i 
> prefer fix the bugs :)

what would be the downside of passing in empty strings? I cannot see any 
serious one. The upside is that the conversion is more mechanic and 
safer as well.

Maybe the return code inversion could be / should be fixed as well, that 
seems like an unnecessary change as well:

  -       return 1;
  +       return 0;
   }
  -__setup("apic=", apic_set_verbosity);
  +early_param("apic", apic_set_verbosity);

Why do early-params have a different return convention from 
usual-params? It's just an unnecessary barrier against conversion to 
early params.

	Ingo
