Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZJVB3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZJVB3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 21:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZJVB3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 21:29:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbZJVB3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 21:29:44 -0400
Date: Wed, 21 Oct 2009 18:26:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com
Subject: Re: Unnecessary overhead with stack protector.
Message-Id: <20091021182636.63edbf72.akpm@linux-foundation.org>
In-Reply-To: <20091015183540.GA8098@redhat.com>
References: <20091015183540.GA8098@redhat.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 14:35:41 -0400 Dave Jones <davej@redhat.com> wrote:

> 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
> made CC_STACKPROTECTOR_ALL not-selectable if someone enables CC_STACKPROTECTOR.
> 
> We've noticed in Fedora that this has introduced noticable overhead on
> some functions, including those which don't even have any on-stack variables.
> 
> According to the gcc manpage, -fstack-protector will protect functions with
> as little as 8 bytes of stack usage. So we're introducing a huge amount
> of overhead, to close a small amount of vulnerability (the >0 && <8 case).
> 
> The overhead as it stands right now means this whole option is unusable for
> a distro kernel without reverting the above commit.
> 

This looks like a fairly serious problem to me, but I'm confused by the
commit ID.  February 2008 - is this correct?

If so, this seems like a rather long period of time in which to make such a
discovery.

Also, the Kconfig fiddle didn't cause the problem - it just revealed it. 
The core problem of increased stack usage and text size should already have
been known (to stackprotector developers, at least).  But it sounds like it
wasn't.

So perhaps this was all triggered by a particular gcc version?
