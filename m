Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYERP5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYERP5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYERP5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:57:33 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:49066 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYERP5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:57:32 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Date: Sun, 18 May 2008 17:57:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
References: <200805171831.08490.j.mell@t-online.de> <20080518150733.GC8100@goodmis.org>
In-Reply-To: <20080518150733.GC8100@goodmis.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805181757.10747.j.mell@t-online.de>
X-ID: VmzuZgZf8hq--C1zTlrQRUGTTj3c00LZsc6h2YPxoZ+HKSSOxb8Ub+KZ6m-pGUrg3M
X-TOI-MSGID: 867f2d2d-87e3-4199-b41b-cf40059ede41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonday, 18. May 2008, you wrote:
> On Sat, May 17, 2008 at 06:31:08PM +0200, J?rgen Mell wrote:
> > I tracked this down to a single kernel configuration option. If
> > CONFIG_PREEMPT is set to 'y' the application will start crashing. If
> > CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the
> > application will run without errors.
> >
> > The problem is reproducible in so far as the error always occurs when
> > CONFIG_PREEMPT is set, but the time to the first occurrence varies
> > greatly from some minutes up to more than 10 CPU hours.
> >
> > I found this error first on an openSUSE kernel 2.6.22.17-0.1-rt. I
> > verified the problem on the following kernel versions:
> >
> > openSUSE 2.6.22.17-0.1-default
> > openSUSE 2.6.23.17-ccj64-rt
> > kernel.org 2.6.26-rc1
> > kernel.org 2.6.26-rc2-git5
>
> So you see this error in both the SuSE RT kernel, *and* mainline
> kernel.org?

Yes, that is correct. The error is present from the 2.6.22 SUSE kernel up 
to the most recent mainline kernel. It is also present in the standard 
SUSE kernel, if I just modify *only* CONFIG_PREEMPT.
What makes me wonder: I am using the machine in a production environment 
for programming, multi-media etc. Why does only the Einstein program catch 
the SIGFPE? Normally I would expect other programs to crash, too, if the 
problem is present. But up to now this never happened.

> If you see it in the kernel.org kernel, can you please do a git-bisect
> to see which commit caused the problem?

This is a bit of a problem. I do not know whether there was *ever* a kernel 
version with CONFIG_PREEMPT and without this problem as I have not tried 
any older kernel version yet. I will go back to SUSE 10.2 and try the 
2.6.18 kernel that comes with it.

Bye,
           Jürgen
