Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbYBMQ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbYBMQ34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbYBMQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:29:49 -0500
Received: from xenotime.net ([66.160.160.81]:35886 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758159AbYBMQ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:29:48 -0500
Date: Wed, 13 Feb 2008 08:29:43 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Sam Ravnborg <sam@ravnborg.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-Id: <20080213082943.26d24d10.rdunlap@xenotime.net>
In-Reply-To: <20080213152900.GA28959@elte.hu>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
	<47B30F05.29637.9A21F9B@pageexec.freemail.hu>
	<20080213152900.GA28959@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:29:00 +0100 Ingo Molnar wrote:

> 
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > patches to get CONFIG_CC_STACKPROTECTOR_ALL actually to work (it 
> > includes the Makefile patch proposed in this thread already).
> > 
> > note that the fix to ACPI is an actual stack corruption bug (caught by 
> > ssp thanks to a lucky stack layout), due to the misuse of the pci 
> > accessor functions, probably a whole-tree audit is in order for 
> > similar bugs.
> > 
> > note also that the vsyscall functions (more precisely, all the code 
> > that goes into .vsyscall* sections) had better be separated into their 
> > own .c files so that they can be compiled without -mcmodel=kernel and 
> > use %fs for getting the ssp cookie, if ssp is desired at all there).
> 
> thanks, i've picked up your patch into x86.git#mm and also made 
> stackprotector-all default-enabled so that we get more test coverage of 
> this critical security feature. x86.git#mm can be picked up via:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> head of the tree:
> 
>   ---------------->
>   commit e1d96d3e489d02b12984fb3c755b0f9a9ae0fe5f
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Wed Feb 13 16:15:34 2008 +0100
> 
>       x86: enable stack-protector by default
> 
>       also enable the rodata and nx tests.
>   <----------------
> 
> your patch booted fine here with stackprotector-all enabled.

Is it signed-off-by: pageexec ?

Couldn't that be a problem?

---
~Randy
