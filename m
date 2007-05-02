Return-Path: <linux-kernel-owner+w=401wt.eu-S2993052AbXEBMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993052AbXEBMGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993060AbXEBMGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:06:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993052AbXEBMGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:06:33 -0400
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
References: <4637AC3D.6000008@freedesktop.org>
	<alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
	<20070502024242.GC6935@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 15:03:59 +0200
In-Reply-To: <20070502024242.GC6935@redhat.com>
Message-ID: <p73abwnxtq8.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:
> 
> #define __page_to_pfn(page)     ((unsigned long)((page) - mem_map) + \
>                                  ARCH_PFN_OFFSET)
> 
> looks like the other two variants of __page_to_pfn also use similar arithmatic.

No way around this. The only way to turn a page into a pfn is to do 
a constant division.  Should be fairly cheap here though.

-Andi (who thinks the sparse warning is dumb; better to look at oprofiles
of hot paths)
