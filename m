Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZAXVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZAXVKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 16:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZAXVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 16:10:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbZAXVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 16:10:27 -0500
Message-ID: <497B83AC.5060801@zytor.com>
Date: Sat, 24 Jan 2009 13:10:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Lattner <clattner@apple.com>
CC: LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>,
       =?UTF-8?B?VMO2csO2?= =?UTF-8?B?ayBFZHdpbg==?= 
	<edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller
 than	input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu> <9A54B928-B0FA-46E9-B963-E24C642F09DA@apple.com>
In-Reply-To: <9A54B928-B0FA-46E9-B963-E24C642F09DA@apple.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lattner wrote:
> 
> We would like to support some more specific cases (e.g. when tying a
> pointer/int to a different size pointer/int) but we currently don't
> intend to support all cases (e.g. tying a FP value to int).  We are in
> this position because the semantics are very vague and hard to reason
> about (and change based on target endianness) and we had many subtle
> bugs in the corner cases.
> 
> Instead of having silent miscompiles, we decided to just reject all the
> "hard" cases and add them back one by one as there is demand.  That way
> users could choose to modify their asms instead of having them be
> potentially silently miscompiled.
> 

The case that matters for the kernel is integer to integer, when a
register is re-used from input to output.

> LLVM 2.5 is in its release process right now, so it will not have
> improvements in this area, but LLVM 2.6 certainly could.  If there is
> interest in building the kernel with 2.5, I think taking the patches
> would be worthwhile.  If that is hopeless anyway, waiting for the
> LLVM-side fixes should be fine.

The patches don't look all that bad to me, but I really want to make
sure we don't keep littering the kernel with workarounds for N different
compilers without getting a track to have them cleaned up.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

