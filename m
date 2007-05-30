Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXE3CPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXE3CPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXE3CPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:15:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56000 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbXE3CPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:15:10 -0400
Date: Tue, 29 May 2007 19:15:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "\"\\\"Tetsuo Handa\\\"\"" <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc2] BUG message during boot.
In-Reply-To: <200705240059.l4O0x9Dr004898@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0705291900480.29202@schroedinger.engr.sgi.com>
References: <200705240059.l4O0x9Dr004898@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, "\"Tetsuo Handa\"" wrote:

> It seems it is harmless because the system can continue running,
> but may be something bad?

Yes it may be harmless... Some thing is asking the slab allocator for 
an object of 0 bytes. 

> Compat vDSO mapped to ffffe000.
> BUG: at mm/slab.c:777 __find_general_cachep()
>  [<c015442d>] __kmalloc+0x4d/0xc8
>  [<c03e2395>] init_table+0x19/0x4a
>  [<c010addb>] mtrr_bp_init+0x176/0x18e
>  [<c03e048c>] check_bugs+0x5/0x3b
>  [<c03d89f0>] start_kernel+0x1e2/0x1eb
>  [<c03d83ec>] unknown_bootoption+0x0/0x181
>  =======================
> Checking 'hlt' instruction... OK.

The fix is in linux-2.6.22-rc2-mm1

