Return-Path: <linux-kernel-owner+w=401wt.eu-S1422629AbXDSUsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422629AbXDSUsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422636AbXDSUsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:48:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422629AbXDSUsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:48:18 -0400
Message-ID: <4627D57C.4070809@redhat.com>
Date: Thu, 19 Apr 2007 16:47:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org> <20070414204924.125386443@goop.org>
In-Reply-To: <20070414204924.125386443@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> head.S creates the very initial pagetable for the kernel.  This just
> maps enough space for the kernel itself, and an allocation bitmap.
> The amount of mapped memory is rounded up to 4Mbytes, and so this
> typically ends up mapping 8Mbytes of memory.
> 
> When booting, pagetable_init() needs to create mappings for all
> lowmem, and the pagetables for these mappings are allocated from the
> free pages around the kernel in low memory.  If the number of
> pagetable pages + kernel size exceeds head.S's initial mapping, it
> will end up faulting on an unmapped page.  This will only happen with
> specific combinations of kernel size and memory size.
> 
> This patch makes sure that head.S also maps enough space to fit the
> kernel pagetables as well as the kernel itself.  It ends up using an
> additional two pages of unreclaimable memory.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Acked-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>,

Is some version of this going in for 2.6.21, or is it not a real problem?
