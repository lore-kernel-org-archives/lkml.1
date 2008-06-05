Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbYFEAuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbYFEAuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 20:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFEAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 20:49:58 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42785 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYFEAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 20:49:57 -0400
Date: Wed, 4 Jun 2008 20:49:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Thorsten Knabe <linux@thorsten-knabe.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
Message-ID: <20080605004925.GA15461@c2.user-mode-linux.org>
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org> <484719C7.2020502@thorsten-knabe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484719C7.2020502@thorsten-knabe.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 12:40:07AM +0200, Thorsten Knabe wrote:
> I can start other 32-bit applications, for example compile an UML
> kernel, within the chroot without leaking task_structs, but as soon as I
> start an UML instance, I see leaked task_structs. Starting and
> immediately shutting down an UML instacne leaks approximately 2000
> task_structs. The number of leaked task_structs on the host seems to be
> equal to the number of processes that have been created (and destroyed)
> within the UML instances.

I misunderstood - I thought you were seeing a task_struct leak within
UML rather than a leak on the host elicited by UML.

> As far as I understand the UML code in the kernel, an UML kernel uses
> some unusual clone() flags when creating new processes, which are seldom
> used by other applications and could be related to the bug.

Yes, it does.  I don't see the flags causing a leak, though.  What
might be more likely (although I really have no idea) is ptrace.
Possibly a reference is held when it should have been dropped.  This
might also show up with strace or gdb.

      	   	   Jeff

-- 
Work email - jdike at linux dot intel dot com
