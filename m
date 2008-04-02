Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYDBWIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYDBWIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYDBWIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:08:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757001AbYDBWID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:08:03 -0400
Date: Wed, 2 Apr 2008 15:07:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <20080402150158.f366370f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804021505160.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <20080402150158.f366370f.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Andrew Morton wrote:
> 
> But then the test-and-set of an already-set flag would newly cause the
> cacheline to be dirtied, requiring additional bus usage to write it back?
> 
> The CPU's test-and-set-bit operation could of course optimise that away in
> this case.  But does it?

No, afaik no current x86 uarch will optimize away the write on a locked 
instuction if it turns out to be unnecessary. 

Can somebody find a timing reason to have the ugly code?

		Linus
