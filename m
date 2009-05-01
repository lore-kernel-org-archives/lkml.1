Return-Path: <linux-kernel-owner+w=401wt.eu-S1751193AbZEAFJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbZEAFJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbZEAFJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:09:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZEAFJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:09:28 -0400
Date: Thu, 30 Apr 2009 22:06:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
 around
Message-Id: <20090430220648.268ab9bb.akpm@linux-foundation.org>
In-Reply-To: <200905011027.46754.knikanth@novell.com>
References: <200904291221.40361.knikanth@novell.com>
	<200904301939.51022.knikanth@novell.com>
	<20090430144526.10b3039a.akpm@linux-foundation.org>
	<200905011027.46754.knikanth@novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 10:27:46 +0530 Nikanth Karthikesan <knikanth@novell.com> wrote:

> I tried with linux/bug.h. But it creates a cyclic dependency. linux/bug.h 
> pulls in linux/module.h => linux/spinlock.h => asm/spinlock.h (which uses 
> atomic_inc) => asm/atomic.h,.

And why on earth does bug.h need module.h?

int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
			 struct module *);

The ever-smelly Elf_Ehdr and Elf_Shdr.

Probably the module_bug_finalize/module_bug_cleanup declarations and
definitions should be in module.h.

