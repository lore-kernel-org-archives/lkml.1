Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZAVT4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZAVT4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZAVT4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:56:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZAVT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:56:42 -0500
Date: Thu, 22 Jan 2009 20:55:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090122195558.GA21118@elte.hu>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com> <20090121210726.GK21473@genesis.frugalware.org> <1232573646.6997.21.camel@localhost.localdomain> <20090122195132.GZ21473@genesis.frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122195132.GZ21473@genesis.frugalware.org>
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


* Miklos Vajna <vmiklos@frugalware.org> wrote:

> On Wed, Jan 21, 2009 at 01:34:06PM -0800, john stultz <johnstul@us.ibm.com> wrote:
> > Miklos: Can you try bisecting this down some?
> 
> I did it two times when I finally realised that it depends on the
> config. So currently I have two config files, with "-good" the clock is
> fine, with "-bad" it's too fast.
> 
> Of course the diff contains unrelated changes as well, I'm trying to 
> find which one is the problematic one.

these look suspect in the good->bad diff:

 # CONFIG_X86_VOYAGER is not set
 # CONFIG_X86_GENERICARCH is not set
 # CONFIG_X86_VSMP is not set
-# CONFIG_X86_VISWS is not set
-# CONFIG_X86_RDC321X is not set
+CONFIG_X86_VISWS=y
+CONFIG_X86_RDC321X=y
 CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
-# CONFIG_PARAVIRT_GUEST is not set
+CONFIG_PARAVIRT_GUEST=y
+# CONFIG_VMI is not set
+CONFIG_KVM_CLOCK=y
+CONFIG_KVM_GUEST=y
+CONFIG_LGUEST_GUEST=y
+CONFIG_PARAVIRT=y
+CONFIG_PARAVIRT_CLOCK=y
+# CONFIG_PARAVIRT_DEBUG is not set
 CONFIG_MEMTEST=y

	Ingo
