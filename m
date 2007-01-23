Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXAWT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXAWT5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965446AbXAWT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:57:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbXAWT5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:57:21 -0500
Date: Tue, 23 Jan 2007 11:57:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@osdl.org>
cc: Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/11] i386 vDSO: use VM_ALWAYSDUMP
In-Reply-To: <20070123114825.21ebc2e3.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701231154030.32200@woody.linux-foundation.org>
References: <20070114053140.351701800E5@magilla.sf.frob.com>
 <20070114053428.900DB1800E5@magilla.sf.frob.com> <20070123114825.21ebc2e3.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jan 2007, Andrew Morton wrote:
>  
>  /*
> + * Helper function for iterating across a vma list.  It ensures that the caller
> + * will visit `gate_vma' prior to terminating the search.

Well, the comment is wrong. The code doesn't actually visit 'gate_vma' if 
the list of VMA's is empty.

Not that the old code did either, so it's not like it's a new bug, but I 
thought I'd point it out anyway. As if we care (but you can probably 
trigger this by having an app that does

	munmap(NULL, TASK_SIZE);

which will cause a SIGSEGV on return (because the stack doesn't exist) and 
then the core-dump should be empty.

Not that I tested anythign that evil anyway, nor do I think we really care 
if it means that the gate_vma doesn't get shown in the core-dump either.

		Linus
