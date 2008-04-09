Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYDIIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYDIIme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYDIIm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:42:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYDIIm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:42:26 -0400
Date: Wed, 9 Apr 2008 10:42:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86 vdso 32-bit vdso-disabling fixes
Message-ID: <20080409084200.GA32466@elte.hu>
References: <20080409082703.B805926F992@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409082703.B805926F992@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> These two patches together address two potential bugs when trying to 
> disable the 32-bit vDSO via sysctl or boot parameters (vdso32=0).
> 
> Currently, every 32-bit exec gets the vDSO mapped even if it's 
> disabled (the process just doesn't get told about it).  Because it's 
> in fact always there, the bug that patch 1/2 fixes cannot happen now.  
> With patch 2/2, it won't be mapped at all when it's disabled, which is 
> one of the things that people might really want when they disable it 
> (so nothing they didn't ask for goes into their address space).
> 
> The 32-bit signal handler setup when SA_RESTORER is not used refers to 
> current->mm->context.vdso without regard to whether the vDSO has been 
> disabled when the process was exec'd.  Patch 1/2 fixes this not to use 
> it when it's null, which becomes possible after patch 2/2.  (This 
> never happens in normal use, because glibc's sigaction call uses 
> SA_RESTORER unless glibc detected the vDSO.)

thanks Roland, applied.

	Ingo
