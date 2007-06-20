Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXFTVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXFTVRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXFTVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:17:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbXFTVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:17:12 -0400
Date: Wed, 20 Jun 2007 14:16:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: righiandr@users.sourceforge.net, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH for 2.6.22] [1/10] i386: bug in i386 MTRR
 initialization
In-Reply-To: <20070620102329.9248A14ACF@wotan.suse.de>
Message-ID: <alpine.LFD.0.98.0706201414160.3593@woody.linux-foundation.org>
References: <200706201223.443613000@suse.de>
 <20070620102329.9248A14ACF@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Andi Kleen wrote:
> 
> From: Andrea Righi <righiandr@users.sourceforge.net>
>
> BUG: at include/linux/slub_def.h:77 kmalloc_index()

This was never a bug, and should have been named a warning. It's also gone 
in the current source-tree, since we instead of warning now just return 
ZERO_SIZE_PTR, and if somebody then dereferences that zero-sized 
allocation, then that is the *real* bug.

So I'm sure the patch description is misleading, but I'm not sure whether 
the patch itself is wrong per se. But I'm dropping it for now.

		Linus
