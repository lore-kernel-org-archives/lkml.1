Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0BMEmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 23:42:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab0BMEmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 23:42:02 -0500
Date: Fri, 12 Feb 2010 20:41:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [PATCH 26/28] kdb,panic,debug_core: Allow the debug core to
 receive a panic before smp_send_stop()
Message-Id: <20100212204141.cc42f298.akpm@linux-foundation.org>
In-Reply-To: <4B75E7AB.4060102@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	<1266014143-29444-27-git-send-email-jason.wessel@windriver.com>
	<20100212150027.f875bbde.akpm@linux-foundation.org>
	<4B75E7AB.4060102@windriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 17:43:39 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:

> >>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> >>  #ifdef CONFIG_DEBUG_BUGVERBOSE
> >>  	dump_stack();
> >> @@ -91,8 +94,6 @@ NORET_TYPE void panic(const char * fmt, ...)
> >>  	 */
> >>  	smp_send_stop();
> >>  
> >> -	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> >> -
> >>  	bust_spinlocks(0);
> >>  
> >>  	if (!panic_blink)
> >>     
> >
> > So the notifier call now happens before all the printks and the kexec
> > and kmsg_dump handling.  What effect does this have upon the code which
> > implements kexec and kmsg_dump?
> >
> >   
> 
> I certainly don't want to break kexec or alter any behavior, does that
> mean kgdb / kdb should hook the kexec for notification?
> 
> I think ideally it is a end user's preference as to if they want in via
> kexec or the kernel debugger.  Calling the smp_send_stop() prior to the
> notifier was a death sentence for the kernel debugger. 
> 
> Perhaps I can move the notifier before smp_send_stop()?

Well.  My question can be simplified to "does this break existing code"?
