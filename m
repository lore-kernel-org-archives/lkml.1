Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbZJIQGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbZJIQGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbZJIQGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:06:07 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:33091 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726AbZJIQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:06:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
Date: Fri, 9 Oct 2009 18:05:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910091805.11249.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, John Kacur wrote:
> 
> I've been staring at the BKL lock in cpuid_open, and I can't see what it 
> is protecting. However, I may have missed something - even something 
> obvious, so comments are welcome.
> 

Hi John,

In general, the lock_kernel() calls in any chardev open() file operation
are the result of the BKL pushdown by Jon Corbet and others, which has happened
some time last year[1]. I'd assume that the vast majority is not needed
at all, so these are an easy target for removal.

	Arnd

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0805.2/0257.html
