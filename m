Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYFAMNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYFAMNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 08:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYFAMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 08:12:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFAMMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 08:12:51 -0400
Date: Sun, 1 Jun 2008 08:12:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: j.mell@t-online.de
cc: LKML <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <76306.1226@compuserve.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
In-Reply-To: <200806011101.06491.j.mell@t-online.de>
Message-ID: <Pine.LNX.4.58.0806010808180.21278@gandalf.stny.rr.com>
References: <200806011101.06491.j.mell@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  Fixed Andi's email and added those that Signed off on the
  problem commit.
]


On Sun, 1 Jun 2008 j.mell@t-online.de wrote:

>
> Hi,
>
> > On Sat, May 17, 2008 at 06:31:08PM +0200, J?rgen Mell wrote:
> > I tracked this down to a single kernel configuration option. If
> > CONFIG_PREEMPT is set to 'y' the application will start crashing.
> > If  CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the
> > application will run without errors.
>
> With lots of help from Heinz-Bernd, Bernd and Oliver of the Einstein@Home
> project I now found the the following:
>
> 1. Einstein@home will crash with trap #8 if the problem is present. The
> error occurs between some minutes after starting Einstein up to more than
> 10 hours after starting Einstein. This seems to depend on how many other
> applications are used on the system (it takes much more time, if only the
> Einstein processes are active on the system).
>
> 2. The error was introduced between kernel.org kernels 2.6.19.7 and 2.6.20.
> It is still present in 2.6.26-rc4
>
> 3. If I revert the patch
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=acc207616a91a413a50fdd8847a747c4a7324167

Hi,

Thanks for bisecting this. I added the commiter and those that signed off
on the problem commit. They are the ones that will need to help you solve
this.

-- Steve


>
> in 2.6.20, Einstein does not crash anymore (program was run for more than
> 30 hours while system was in normal use with programming, multi-media
> etc.). Unfortunately git refuses to revert this patch in 2.6.26-rc4.
>
> Now I need some help as I am not an expert in this area. What I assume is
> that either the state of the FPU is not always restored (perhaps if the
> process is swapped between the two cores?) or it is restored more than
> once. Please keep in mind, that I am always running two Einstein processes
> simultaneously on my two cores!
> I am willing to do further testing of this problem if someone can give me a
> hint how to continue.
>
> Bye,
>
>           Jürgen
>
