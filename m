Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXITV7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXITV7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXITV7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:59:23 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:31387 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbXITV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:59:21 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46F2ED1E.3090407@am.sony.com>
Date: Thu, 20 Sep 2007 14:58:54 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-tiny@selenic.com, linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
In-Reply-To: <200709201538.43093.rob@landley.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2007 21:59:18.0355 (UTC) FILETIME=[7DF8EA30:01C7FBD1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> So instead of:
>   printk(KERN_NOTICE "Fruit=%d\n", banana);
> It would now be:
>   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> 
> Change the header from:
>   #define KERN_NOTICE "<5>"
> to:
>   #define KERN_NOTICE 5
> 
> Then you can change the printk guts to do something vaguely like (untested):
> #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">" arg2, __VA_ARGS__)
...
> [then] the
> compiler's dead code eliminator zaps the printks you don't care about so they
> don't bloat the kernel image.

I agree in principal with the idea, but there are some major
practical wrinkles that would have to be worked through.

First, not all printks that are missing a log level should have one.
People do stuff like this:

printk(KERN_INFO "interesting info follows:");
...
printk("var5: %d\n", var5);

Or even things that evaluate to:
printk("");

The code inside printk currently has to examine the
strings, looking for line feeds and inserting log levels.

Given that there are about 60,000 printks in the kernel (and that's
not counting wrappers like dprintk() and other locally-defined
functions and macros) it would be a huge task to examine the code
and differentiate strings that really start a new log message
(and thus should have an attached log level) and strings
that don't.
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

