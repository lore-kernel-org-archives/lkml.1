Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZG1Hsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZG1Hsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZG1Hsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:48:38 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:53168 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZG1Hsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:48:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: NMI between switch_mm and switch_to
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19054.33655.297932.261580@cargo.ozlabs.ibm.com>
References: <19054.33655.297932.261580@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:51:12 +0200
Message-Id: <1248767472.6987.2806.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 14:49 +1000, Paul Mackerras wrote:
> Ben H. suggested there might be a problem if we get a PMU interrupt
> and try to do a stack trace of userspace in the interval between when
> we call switch_mm() from sched.c:context_switch() and when we call
> switch_to().  If we get an NMI in that interval and do a stack trace
> of userspace, we'll see the registers of the old task but when we peek
> at user addresses we'll see the memory image for the new task, so the
> stack trace we get will be completely bogus.
> 
> Is this in fact also a problem on x86, or is there some subtle reason
> why it can't happen there?

I can't spot one, maybe Ingo can when he's back :-)

So I think this is very good spotting from Ben.

We could use preempt notifiers (or put in our own hooks) to disable
callchains during the context switch I suppose.

