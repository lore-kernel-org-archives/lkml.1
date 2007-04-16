Return-Path: <linux-kernel-owner+w=401wt.eu-S1030817AbXDPQOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817AbXDPQOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXDPQOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:14:03 -0400
Received: from ozlabs.org ([203.10.76.45]:35085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030817AbXDPQOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:14:01 -0400
Date: Mon, 16 Apr 2007 11:10:39 -0500
From: Anton Blanchard <anton@samba.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
Message-ID: <20070416161039.GA979@kryten>
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au> <461DCDDA.2030502@yahoo.com.au> <461DDE44.2040409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461DDE44.2040409@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> Making the pte clean also needs to clear the hardware writable
> bit on architectures where we do pte dirtying in software.
> 
> If we don't, we would have corruption problems all over the VM,
> for example in the code around pte_clean_one :)
> 
> >But as Linus recently said, even hardware handled faults still
> >take expensive microarchitectural traps.
> 
> Nowhere near as expensive as a full page fault, though...

Unfortunately it will be expensive on architectures that have software
referenced and changed. It would be great if we could just leave them
dirty in the pagetables and transition between a clean and dirty state
via madvise calls, but thats just wishful thinking on my part :)

Anton
