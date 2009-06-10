Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZFJGWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZFJGWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZFJGW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:22:29 -0400
Received: from ozlabs.org ([203.10.76.45]:41192 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZFJGWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:22:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Date: Wed, 10 Jun 2009 14:25:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Dave Jones <davej@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
References: <4A2835D8.6040903@kernel.org> <20090609162808.GC2491@redhat.com> <alpine.LFD.2.01.0906090940160.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906090940160.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101425.43127.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 02:11:08 am Linus Torvalds wrote:
> On Tue, 9 Jun 2009, Dave Jones wrote:
> > work_on_cpu()'s definition could probably use a fat comment describing
> > why it sucks.
>
> No, it should be renamed.
>
> The problem is that it _sounds_ like a nice thing to do.

Yeah, it used to be *faster* than the stupid mug-own-cpumask code it was 
supposed to replace.   Then we hit all those deadlocks using keventd, and 
revulsion against YA per-cpu thread, and ended up with the current sucky 
version.

Rusty.
