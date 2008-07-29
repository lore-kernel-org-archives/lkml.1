Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbYG2QWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbYG2QWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYG2QW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:22:29 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:18135 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYG2QW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=DVOiqfV05ygVyeZAVJKyIIw5KLbQ9BL3c/qddNW3p9zzX5epl5kXRvzBnu84X7mJR6
         x0Q5opcRgiaiGc3+VZ9epaQnBFyW8/ehDuHMT28o3xqjFpPgqd6j4JpNmM1m+D/fY6oU
         h32bX2C39aS/U4KR/GcZ9AoG97Lb/mAkhaJkY=
Date: Tue, 29 Jul 2008 19:22:14 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shaohua.li@intel.com, tigran@aivazian.fsnet.co.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Oops in microcode sysfs registration,
Message-ID: <20080729192214.2d3a4ca5@daedalus.pq.iki.fi>
In-Reply-To: <200807291457.58408.alistair@devzero.co.uk>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	<200807291457.58408.alistair@devzero.co.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 14:57:58 +0100
Alistair John Strachan <alistair@devzero.co.uk> wrote:

> Noticing pq's mmiotrace was merged I tried to get a trace of the proprietary
> NVIDIA blob. Normally I wouldn't waste your time posting a tainted oops,
> however in this case it doesn't look related to the proprietary garbage and I
> think there's a real bug somewhere.
> 
> As I understand it, the mmiotrace tracing framework requires only one logical
> CPU to be active, automatically offlining the other CPUs. When mmiotrace is
> disabled, it automatically re-enables the CPUs it offlined. If I offline the
> spare CPUs myself, prior to enabling mmiotrace, I do not see the issue I'm
> about to describe. That's why tracing people have been CCed, even though that
> could be a red herring.

I have a wild hunch...
Could you try the following:
1. with all cpus enabled, load the nvidia proprietary driver
2. start and quit X
3. disable a cpu by hand
4. unload the proprietary driver
5. enable the cpu by hand

I have a vague recollection of the nvidia blob doing something bad
with notifiers, so if that crashes, and it does not crash when you
leave step 4 out, it's an nvidia problem. I assume you unloaded the
blob before disabling mmiotrace, right?

You may need to alter the sequence of things, but my guess is that
the blob may leave a notifier registered even when it is unloaded,
so it crashes when the notifier chain is traversed. I'm not sure the
backtrace really supports this scenario, but worth to try.

> The full dmesg and kernel config are available from
> http://devzero.co.uk/~alistair/2.6.27-rc1-mc-oops/
...
> Also, I'm sure this is reproducible without the NVIDIA garbage, but I was too lazy
> to test it. If you want me to repeat the experiment without the driver I would be
> more than happy to do so.

I'm not sure people are willing to look into this without a clean report,
so this would be cool. There's even a test module for mmiotrace in the
kernel, but I doubt it would make difference to use it or not, when trying
to reproduce the crash without the blob.

Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
