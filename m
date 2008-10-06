Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYJFJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYJFJuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYJFJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:50:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYJFJu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:50:28 -0400
Date: Mon, 6 Oct 2008 11:56:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Implement personality ADDR_LIMIT_32BIT
Message-ID: <20081006095628.GE3180@one.firstfloor.org>
References: <1223017469-5158-1-git-send-email-kirill@shutemov.name> <20081003080244.GC25408@elte.hu> <20081003092550.GA8669@localhost.localdomain> <87abdintds.fsf@basil.nowhere.org> <20081006081717.GA20072@localhost.localdomain> <20081006084246.GC3180@one.firstfloor.org> <20081006091709.GB20852@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006091709.GB20852@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And personality() is not thread local/safe, so it's not a particularly
> > good interface to use later.
> 
> qemu can call personality() before any threads will be created.

It still makes it unsuitable for a lot of other applications.
e.g. a JVM using 32bit pointers couldn't use it because it would
affect native C threads running in the same process.

> 
> > Per system call switches are preferable
> > and more flexible.
> 
> Per syscall switches are cool, but I don't see any advantage from it for 
> qemu.

Linux interfaces are not supposed to be "interfaces for qemu" but generally
applicable interfaces.

-Andi
-- 
ak@linux.intel.com
