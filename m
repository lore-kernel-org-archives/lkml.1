Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYHWWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYHWWxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYHWWxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 18:53:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:38873 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYHWWxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 18:53:01 -0400
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michael Buesch <mb@bu3sch.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200808231610.46473.mb@bu3sch.de>
References: <200808231610.46473.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 24 Aug 2008 08:52:49 +1000
Message-Id: <1219531969.21386.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-23 at 16:10 +0200, Michael Buesch wrote:
> I am seeing random kernel and userland application
> crashes on a Powerbook running a 2.6.27-rc3 based kernel (wireless-testing.git).
> 
> The crashes did recently appear. It might be the case that they were
> introduced with the merge of 2.6.27-rc1 into wireless-testing.
> I'm not sure on that one, however. Just a guess. I still need to
> do more testing (also on vanilla upstream kernels).
> 
> The crashes are completely random and they look like bad hardware.
> However I cannot reproduce on 2.6.25.9 (That's a kernel I still had
> installed, so I tried that one). So it most likely is _not_ caused
> by faulty hardware.
> 
> The crashes are hard to reproduce, and happen about every 20 minutes
> when compiling a kernel tree. (gcc segfaults). Sometimes the kernel
> oopses in random places with pointer dereference faults.
> 
> Is this a known issue?
> I'm going to bisect this one, but it will take a lot of time, as reproducing
> takes about 20 minutes. So that's about an hour for one test round.
> 
> The kernel configuration is the following:

Random guess:

CONFIG_FRAME_POINTER=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y

Note sure what those together do, check if you have any file compiled
with -fno-omit-frame-pointer and if you do, try to change things so
that you don't ... we found some miscompiles when that is set, exposed
by FTRACE typically (which you don't have enabled) but possibly by other
things.

Ben.


