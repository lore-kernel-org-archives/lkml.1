Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXKRWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXKRWT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXKRWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:19:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXKRWTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:19:51 -0500
Date: Sun, 18 Nov 2007 14:17:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Need help with register_page_fault_notifier() replacement in
 2.6.24
Message-ID: <20071118141741.28738bee@laptopd505.fenrus.org>
In-Reply-To: <1195407616.26789.15.camel@dv>
References: <1195407616.26789.15.camel@dv>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 12:40:16 -0500
Pavel Roskin <proski@gnu.org> wrote:

> Hello!
> 
> I'm trying to update a special tracing version of madwifi (driver for
> Atheros wireless cards) for Linux 2.6.24.  This version was created to
> help reverse engineering the non-free part of the driver (also known
> as HAL, hardware abstraction layer).
> 
> The problem is that functions register_page_fault_notifier() and
> unregister_page_fault_notifier() are gone in the current kernel git
> repository.
> 
> They are needed to intercept access to the card by causing page fault
> and intercepting it.
> 
> Those functions were removed on i386 platform because kprobes now
> registers the flat handler directly.  The log says that other callers
> are supposed to use kprobes now.
> 
> But what would be the right way to do it?  I can intercept
> do_page_fault() with kprobes, but that looks unsafe, since
> do_page_fault() is used by kprobes internally.
> 
> Or maybe I should install a fault handler with register_kprobe()?  The
> problem is, it is only called for faults in kp->pre_handler and
> kp->post_handler and for single-stepping.  I don't want to single-step
> anything, and moving all driver functionality in kp->pre_handler would
> be strange.
> 
> Perhaps I'm missing something obvious.  Any help will be appreciated.
> 

if it's just for a custom case (as it sounds like).. a simple small
change to the pagefault handler sounds like the easiest thing to do...
(eg just a direct function call to what would have been your notifier)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
