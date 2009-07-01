Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZGAU4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZGAU4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZGAU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:56:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbZGAU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:56:44 -0400
Date: Wed, 1 Jul 2009 13:56:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, nhorman@tuxdriver.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kmod: Fix race in usermodehelper code
Message-Id: <20090701135631.41e590f9.akpm@linux-foundation.org>
In-Reply-To: <20090701024803.GA19659@localhost.localdomain>
References: <20090701024803.GA19659@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 22:48:03 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> User Mode Helper: Fix race in UMH_WAIT_EXEC case
> 
> The user mode helper code has a race in it.  call_usermodehelper_exec takes an
> allocated subprocess_info structure, which it passes to a workqueue, and then
> passes it to a kernel thread which it creates, after which it calls complete to
> signal to the caller of call_usremodehelper_exec that it can free the
> subprocess_info struct.  But since we use that structure in the created thread,
> we can't call complete from __call_usermodehelper, which is where we create the
> kernel_thread.  We need to call complete from within the kernel thread and then
> not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
> successfully by me.
> 

<stares at the code for ten minutes>

Geeze that's getting complex, isn't it?  The patch looks OK.  I think.

I wonder why people aren't reporting this.  Perhaps CLONE_VFORK plus
child-runs-first?  (_does_ the chld run first?  We seem to have changed
it a couple of times)


