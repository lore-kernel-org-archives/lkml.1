Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXCPH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXCPH3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXCPH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:29:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53137 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbXCPH3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:29:10 -0400
Date: Fri, 16 Mar 2007 09:29:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
In-Reply-To: <45FA458C.8050605@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
 <45FA458C.8050605@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> > 	/*
> > - 	 * Not holding ->mmap_sem here.
> > + 	 * Not holding ->mmap_sem here but we must watch out for page
> > + 	 * faults and after the shared mappings have been taken down
> > + 	 * and sys_mmap() trying to remap the revoked range.
> >   */
> >   vma->vm_flags |= VM_REVOKED;
> >   smp_mb();
> > @@ -455,7 +457,7 @@ 	int err = 0;

On Fri, 16 Mar 2007, Nick Piggin wrote:
> You're still modifying vm_flags without down_write mmap_sem, so this will
> corrupt vm_flags.

Uhm, you're right, two concurrent writes and we can lose some bits so a 
barrier doesn't work. Too bad as we're under mapping->i_mmap_lock here and 
thus cannot take ->mmap_sep...
