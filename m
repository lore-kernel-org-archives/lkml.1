Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYE0Vl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYE0Vl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbYE0Vlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758613AbYE0Vlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:41:46 -0400
Date: Tue, 27 May 2008 14:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] debug printk infrastructure
Message-Id: <20080527143959.ccdad922.akpm@linux-foundation.org>
In-Reply-To: <20080522211331.GA28070@redhat.com>
References: <20080522211331.GA28070@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 17:13:31 -0400
Jason Baron <jbaron@redhat.com> wrote:

> hi,

Hi.

Three or four thousand people received your patches, but only one chose
to get in and review them.  Why I have so much more spare time than
everyone else is, I guess, a topic which we should examine separately. 
Sigh.

> So i've attempted to make this infrastrucutre general enough to be used by the
> kernel as a whole. The basic interfaces i'm using are the basic, 'pr_debug()',
> and 'dev_dbg()' calls.

How are you using them?  What is the interface?  What do the patches
do?  Please pretend that I have totally forgotten everything which went
before and my mind is now a virginal blank.  That's actually not far
from reality.

> And then i've added:
> 
> -register_dev_dbg_handler(parent, type, max, init)
> This registers a handler that can support level, or flag printks. 'type' is
> either 'TYPE_LEVEL' or 'TYPE_FLAG'. The 'parent' field can be used to support
> a hierarchical debugging between modules, for example where we want to share
> the same levels across modules. 'init' is the initial setting for the flag
> or level. 'max' is currently unused and probably should be discarded.

uh, I think I vaguely understand what you're getting at here.  Not
knowing what type `parent' has makes that harder that it needs to be.

What is "hierarchical debugging between modules" and why would I want one?

> -dev_dbg_level(value, dev, format, ...)
> This call is used by code in the core driver as its interface into 'printk'.
> 'value' is the level or flag value for the particular printk. So modules can
> do: #define dprintk dev_dbg_level(value, dev, format, ...)

ok, I guess.  But I'm a bit lost on the earlier stuff, so this is a bit
eye-glazing.
 
> -dev_dbg_enabled(value)
> This call is used to allow the infrastructure to be more flexible and handle
> blocks of printks or even blocks of other debugging code.

How would one do that?

Perhaps some suitably-explained code examples would help here.  In the
changelog text.

> -'pr_debug' and 'dev_dbg' can continue to be used as before (no API change),
> but this infrastructure automatically detects where these calls are and displays
> the modules that have them in a debugfs file: debug/dynamic_printk/modules
> 
> The debugfs file, then lists all the modules that can be 'enabled' for dynamic
> printk calls. Currently, the file has a 4 column format (excerpt from my system:
> 
> <module_name> <enabled/disabled> <current level/flag setting> <# of call sites>
> 
> 8250 0 0 2
> acpi_cpufreq 0 0 1
> aio 0 0 24
> backlight 0 0 3

ok..

I'm not a big fan of the relative pathnames in debugfs.  Such as
"debug/dynamic_printk/modules".  Given that people will hopefully write
userspace tools which access these files I believe that it is valuable
for the kernel developers to provide them with a well-known,
predictable (ie: fixed) absolute pathname.  Or at least a standardised
well-known way of locating that file at runtime.

Maybe such a mechanism already exists for debugfs - I haven't been
keeping up.  But if I were writing a userspace script which needed to
access debug/dynamic_printk/modules I'd be wondering "how the heck do I
reliably locate that file on everyone's machines?".

> I've converted a few subsysmts to this infrastructure to provide some examples
> of what it can do: module.c bonding aio and cpufreq (including sub-drivers).
> 
> I realize the code is a bit rough around the edges, but the basic idea is here, 
> and i'm looking for feedback on the approach.
> 
> todo:
> 
> *free memory used in text sections to detect call sites
> *provide potential level settings in the debugfs file
> *convert more modules/subsystems
> *tidy up lib/dynamic_printk.c

I hate to sound nitpicky here, but the lack of suitably detailed
description here really does make the patches harder to understand and
harder to review.  Ideally, I'd like to fully understand what you have
set out to achieve before getting in there and looking at how you have
sought to achieve it.


I believe this is an important effort - please persist.  I _think_ what
you have here looks good and promising, but it's a little hard to get
the old head around it all.

