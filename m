Return-Path: <linux-kernel-owner+w=401wt.eu-S966512AbXEVStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966512AbXEVStT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbXEVStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:49:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXEVStM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:49:12 -0400
Date: Tue, 22 May 2007 14:48:59 -0400
From: Dave Jones <davej@redhat.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Performance Stats: Kernel patch
Message-ID: <20070522184859.GD12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Maxim Uvarov <muvarov@ru.mvista.com>,
	LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
References: <20070522171950.23728.95735.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522171950.23728.95735.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 05:19:52PM +0000, Maxim Uvarov wrote:

 > diff --git a/include/asm-i386/thread_info.h b/include/asm-i386/thread_info.h
 > index 4b187bb..bccfd6a 100644
 > --- a/include/asm-i386/thread_info.h
 > +++ b/include/asm-i386/thread_info.h
 > @@ -33,6 +33,7 @@ struct thread_info {
 >  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
 >  
 >  
 > +	unsigned long		syscall_count;	/* Syscall counter */
 >  	mm_segment_t		addr_limit;	/* thread address space:
 >  					 	   0-0xBFFFFFFF for user-thead
 >  						   0-0xFFFFFFFF for kernel-thread

It seems a bit unkind to bloat up the thread_info for every process
of every user when the common case will be people that don't care about
this feature at all.

Especially when the same information could be got from ptrace.

	Dave

-- 
http://www.codemonkey.org.uk
