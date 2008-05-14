Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYENIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYENIdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYENIdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:33:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYENIdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:33:05 -0400
Message-ID: <482AA3BD.1030600@firstfloor.org>
Date: Wed, 14 May 2008 10:33:01 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] common implementation of iterative div/mod
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>	<481DF3D8.3010108@shaw.ca>	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>	<48217674.8080903@goop.org>	<48231959.4050406@goop.org> <20080513234627.30476c20.akpm@linux-foundation.org> <482A95BB.1000001@goop.org>
In-Reply-To: <482A95BB.1000001@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> 
> arch/x86/vdso/vclock_gettime.c has its own copies of other kernel
> functions which it can't directly call.  We could add
> timespec_add_ns()/iter_div_u64_rem() to that list, though its pretty
> hacky.  Could we link lib/div64.o into the vdso?

You would need to annotate it and have a separate object file for the
different sections. Also it would need to be compiled PIC.

Inlining is better.

-Andi

