Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXLFUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXLFUU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXLFUUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:20:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:34014 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXLFUUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:20:13 -0500
Date: Thu, 6 Dec 2007 15:19:29 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Customize tlb.h
Message-ID: <20071206201929.GA9366@c2.user-mode-linux.org>
References: <20071206170640.GA7420@c2.user-mode-linux.org> <20071206114642.555a0749.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206114642.555a0749.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 11:46:42AM -0800, Andrew Morton wrote:
> > +void flush_tlb_mm(struct mm_struct *mm)
> > +{
> > +	struct vm_area_struct *vma = mm->mmap;
> > +
> > +	if (atomic_read(&mm->mm_users) == 0)
> > +		return;
> 
> Under which circumstances does this test succeed?

Sigh, none.  The other copy obviously succeeds during exit - this one
isn't needed.

> This file rather needs an inclusion of percpu.h.  I guess you got
> lucky.

Yup, drop this, and I'll send a fixed version.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
