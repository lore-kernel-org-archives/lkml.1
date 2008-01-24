Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYAXHQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYAXHQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYAXHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:16:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:43981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbYAXHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:16:43 -0500
To: Matthias Wolle <Matthias.Wolle@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LowFree/LowMem problem
From: Andi Kleen <andi@firstfloor.org>
References: <200801210632.42497.Matthias.Wolle@gmx.de>
	<20080123140639.828566dd.akpm@linux-foundation.org>
	<200801232340.54258.Matthias.Wolle@gmx.de>
Date: Thu, 24 Jan 2008 08:16:41 +0100
In-Reply-To: <200801232340.54258.Matthias.Wolle@gmx.de> (Matthias Wolle's message of "Wed\, 23 Jan 2008 23\:40\:54 +0100")
Message-ID: <p73d4rrae1y.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Wolle <Matthias.Wolle@gmx.de> writes:

> Jan 17 23:31:58 franklin72 kernel: sshd invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
> Jan 17 23:31:58 franklin72 kernel: cat invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
> Jan 17 23:31:58 franklin72 kernel:  [<c014af39>] out_of_memory+0x69/0x1a4
> Jan 17 23:31:58 franklin72 kernel:  [<c014c588>] __alloc_pages+0x20a/0x291
> Jan 17 23:31:58 franklin72 kernel:  [<c0153618>] __pte_alloc+0x11/0x94

Do you perhaps have a kernel compiled without CONFIG_HIGHPTE? Normally
__pte_alloc should be able to allocate highmem unless that option is 
not set. Before HIGHPTE was implemented running out of low memory
due to page tables was pretty common.

BTW the ultimate fix for most lowmem problems is to go 64bit

-Andi
