Return-Path: <linux-kernel-owner+w=401wt.eu-S935945AbXFGB1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935945AbXFGB1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbXFGB1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:27:35 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53725 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938AbXFGB1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:27:35 -0400
Date: Thu, 7 Jun 2007 10:26:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: init_task & Co.
Message-ID: <20070607012622.GA14234@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0706061722390.10383@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706061722390.10383@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:26:49PM -0700, Davide Libenzi wrote:
> I'm sure there's a good reason behind, but why are those variables 
> replicated in every architecture?
> Those are global variables, defined in global include files, and AFAICS 
> they could be moved in a single kernel/init_task.c file. No?
> 
Except they aren't all the same. At the very least, most architectures
don't agree on the linker section, some don't agree on alignment, and
others don't agree on initialization. Most people set the initial stack
from assembly on entry, others do it differently.

Having said that, there likely are some things that could be made
generic, it's basically just init_task and init_thread_union where there
are disagreements. The rest could likely be stashed in
kernel/init_task.c (although you'd have to carefully examine the
alignment for each architecture, particularly the ones that have special
__asm__ labels).

Perhaps having everyone use the same linker section for init_task and
moving that to asm-generic/vmlinux.lds.h is a reasonable first step.
