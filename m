Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXEKIJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXEKIJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXEKIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:09:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:43960 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXEKIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:09:16 -0400
Date: Fri, 11 May 2007 11:06:36 +0200
From: Andi Kleen <ak@suse.de>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Current git fails to compile on AMD64 for three days in a row
Message-ID: <20070511090636.GQ2012@bingen.suse.de>
References: <20070510151642.GH26751@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510151642.GH26751@iucha.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 10:16:43AM -0500, Florin Iucha wrote:
> I just pulled the current git (de5603748af8bf7deac403e6ba92887f8d18e812)
> and tried to compile it on my AMD64 box, to test Chuck's RPC fix.  It
> fails:
> 
>    arch/x86_64/kernel/head64.c: In function ???x86_64_start_kernel???:
>    arch/x86_64/kernel/head64.c:70: error: size of array ???type name??? is negative
> 
> It is failing in the same way since Monday.

It's a BUILD_BUG_ON -- your relocatable base address in CONFIG 
needs to be a multiple of 2MB as documented.

There is a patch floating around to turn this into an #error which
might be more clear.
-Andi
