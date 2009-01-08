Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZAHGq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZAHGq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZAHGqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:46:48 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28788 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZAHGqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:46:47 -0500
X-IronPort-AV: E=Sophos;i="4.37,231,1231113600"; 
   d="scan'208";a="58682690"
From: Roland Dreier <rdreier@cisco.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Om <om.turyx@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 64 bit PCI access using MMX register -- how?
References: <496534BC.4060603@gmail.com>
	<20090107233929.60ef8d98@lxorguk.ukuu.org.uk>
	<8763kqxs2p.fsf@basil.nowhere.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 Jan 2009 22:46:45 -0800
In-Reply-To: <8763kqxs2p.fsf@basil.nowhere.org> (Andi Kleen's message of "Thu,
	08 Jan 2009 06:52:30 +0100")
Message-ID: <adahc4as3ai.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2009 06:46:46.0209 (UTC) FILETIME=[DFC77310:01C9715C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I think he was ok because he saved the MMX state by itself, except:
 > 
 > - There was no guarantee that the FPU is in MMX state, not x87 state
 > - He'll often get a lazy fpu save exception. This used to BUG() 
 > in some cases when invoked from kernel space (but that might have been
 > changed now). Better is to disable this explicitely around 
 > the access (like in kernel_fpu_begin()/end())
 > - Doing this all properly is fairly expensive and I suspect
 > just using a lock will be cheaper.

I had some code a long time ago that used SSE (I think movlps was the
opcode I chose) to get an atomic 64-bit PIO operation.  To do that, I
just needed to disable preemption and save/restore cr0 around the SSE
operation, and just save/restore the single xmm register I used.  Of
course it only works on CPUs that have SSE.  That avoids the nastiness
of x87/mmx state, but in the end a spinlock around two readl()s was
faster and a ton simpler, so I threw all that code away.

 - R.
