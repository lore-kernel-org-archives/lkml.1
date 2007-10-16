Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbXJPR1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbXJPR1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbXJPR1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:27:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXJPR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:27:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=MrTDpvecBcSTGZ7EMDhkYeXL/tKDd2VqsfFsF2pfYpZHqD/pFeuXORWAsrR1TrZiy
	3d7h1chdbCCvTvx0Xub1A==
Date: Tue, 16 Oct 2007 10:25:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: maps3: introduce task_size_of for all arches (updated v4)
In-Reply-To: <1192555093.6118.164.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710161025050.11410@chino.kir.corp.google.com>
References: <3.290135367@selenic.com>  <alpine.DEB.0.9999.0710151643260.18722@chino.kir.corp.google.com>  <1192494989.6118.142.camel@localhost>  <alpine.DEB.0.9999.0710151924420.11508@chino.kir.corp.google.com> <1192555093.6118.164.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Dave Hansen wrote:

> For the /proc/<pid>/pagemap code[1], we need to able to query how
> much virtual address space a particular task has.  The trick is
> that we do it through /proc and can't use TASK_SIZE since it
> references "current" on some arches.  The process opening the
> /proc file might be a 32-bit process opening a 64-bit process's
> pagemap file.
> 
> x86_64 already has a TASK_SIZE_OF() macro:
> 
> #define TASK_SIZE_OF(child)     ((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
> 
> I'd like to have that for other architectures.  So, add it
> for all the architectures that actually use "current" in 
> their TASK_SIZE.  For the others, just add a quick #define
> in sched.h to use plain old TASK_SIZE.
> 
> 1. http://www.linuxworld.com/news/2007/042407-kernel.html
> 
> - MIPS portion from Ralf Baechle <ralf@linux-mips.org>
> 
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: David Rientjes <rientjes@google.com>
