Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYEGKg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYEGKg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 06:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYEGKgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 06:36:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:60197 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753216AbYEGKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 06:36:18 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/XLkIef3zXwgT39Wsh+3fEwarAarTBQ/ENcqJvhF
	E8IM5fRSSK5Tsv
Date: Wed, 7 May 2008 12:36:15 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Oops with strace_test
Message-ID: <20080507103615.GC2340@alice>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080506121005.GJ32591@elte.hu>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 12:34:45 up  1:51,  1 user,  load average: 0.23, 0.25, 0.23
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frederik Deweerdt <deweerdt@free.fr> wrote:
> 
> > Hi Eric,
> > 
> > This appears to be caused by init_fpu() missing from the 
> > restore_sigcontext->restore_i387->restore_fpu_checking code path.
> > 
> > I believe that moving the init_fpu() call from math_state_restore to 
> > restore_fpu_checking should fix the problem?

sadly the patch does not work for me :( I still get the oopses. I am
running this on a 32 Bit CPU, so arch/x86/kernel/traps_64.c doesnt get
compiled. I tried removing the same part from traps_32.c but then
the kernel oopses before netconsole is active.

Greetings, Eric
