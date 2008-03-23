Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbYCWUQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbYCWUQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 16:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYCWUPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 16:15:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:55018 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYCWUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 16:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MURuwoIEurBXdOPsKgVJbrTvboRmxjWmnPcbaqx7mpymCcV7m32MAaSXWOwuQqa7KfCxLn8FaxJOEzdOv0o/3CAUZsaDJ6jLVOa3j2cxi+qJkPvObF2QEkM3Pu3U5PlSzPJ5m9QpO97zdHv0RiChJ9cBUiopSspwm1yuI+fWsjQ=
Message-ID: <86802c440803231315q2373ec0fp74df1c583ff5695b@mail.gmail.com>
Date: Sun, 23 Mar 2008 13:15:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] documentation: nmi_watchdog=2 works on x86_64 (was: 2.6.25-rc: complete lockup on boot/start of X (bisected))
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080323200625.GB6028@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy>
	 <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy>
	 <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy>
	 <20080323184427.GA6691@joi> <1206299168.6437.119.camel@lappy>
	 <20080323200625.GB6028@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 1:06 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Sun, Mar 23, 2008 at 08:06:08PM +0100, Peter Zijlstra wrote:
>  > On Sun, 2008-03-23 at 19:46 +0100, Marcin Slusarz wrote:
>  >
>  > > 4 different lockups:
>  > > http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.03.23-lockup/
>  >
>  > Brilliant, these are extremely helpful.
>  >
>  > What seems to happen is a classic xtime deadlock, doing a xtime
>  > seq_readlock while holding a seq_writelock.
>  >
>  > Only need to figure out _why_ that is happening....
>  >
>  > > Are there any downsides of using nmi_watchdog=2 all the time?
>  >
>  > Some machines are said to not boot due to NMIs, hence the default is
>  > off, but afaik, _if_ it works there are no downsides aside from the
>  > slight NMI handling overhead.
>  >
>  > > ps: Documentation/nmi_watchdog.txt says: "Currently, local APIC mode
>  > > (nmi_watchdog=2) does not work on x86-64.". It's not true, so maybe someone
>  > > should update this file?
>  >
>  > Care to send a patch to the x86 maintainers? :-)
>  >
>
>  ---
>  documentation: nmi_watchdog=2 works on x86_64
>
>  Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>  Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  ---
>   Documentation/nmi_watchdog.txt |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
>  diff --git a/Documentation/nmi_watchdog.txt b/Documentation/nmi_watchdog.txt
>  index c025a45..757c729 100644
>  --- a/Documentation/nmi_watchdog.txt
>  +++ b/Documentation/nmi_watchdog.txt
>  @@ -23,8 +23,7 @@ kernel debugging options, such as Kernel Stack Meter or Kernel Tracer,
>   may implicitly disable the NMI watchdog.]
>
>   For x86-64, the needed APIC is always compiled in, and the NMI watchdog is
>  -always enabled with I/O-APIC mode (nmi_watchdog=1). Currently, local APIC
>  -mode (nmi_watchdog=2) does not work on x86-64.
>  +always enabled with I/O-APIC mode (nmi_watchdog=1).
>
>   Using local APIC (nmi_watchdog=2) needs the first performance register, so
>   you can't use it for other purposes (such as high precision performance
>  --
anyone has nmi_watchdog=1 works on x86_64 with amd platform?

or nmi_watchdog=1 only works with intel box?

maybe we can default that to different value according to different
cpu vendor...

YH
