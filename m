Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZC3KnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZC3KnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZC3Kmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:42:49 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:56742 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZC3Kmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:42:49 -0400
Date: Mon, 30 Mar 2009 12:42:11 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
Message-ID: <20090330124211.2476207c@skybase>
In-Reply-To: <49D099F0.3000807@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325150035.541e707a@skybase>
	<49CA3C2C.5030702@kernel.org>
	<49D099F0.3000807@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 19:07:44 +0900
Tejun Heo <tj@kernel.org> wrote:

> Okay, this should keep s390 and alpha working till proper solution is
> found.  Martin, can you please verify?  Ingo, please feel free to push
> this upstream (or -next) once Martin acks.

Looks good, everything compiles and the static per-cpu variables are
resolved via GOTENT:

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

For the proper solution, the easiest fix is imho to define a
variant of SHIFT_PERCPU_PTR. The macro is currently used for dynamic
pointers and for per-cpu symbols. We only want to use the GOTENT
indirection for per-cpu symbols. So why don't we split it into
1) SHIFT_PERCPU_SYMBOL for per-cpu symbols and
2) SHIFT_PERCPU_PTR for dynamically allocated pointers?
For s390 the first would be the current SHIFT_PERCPU_PTR macro, the
second would be a simple RELOC_HIDE. The patch would be really
short ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

