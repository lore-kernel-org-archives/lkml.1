Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZB0VkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZB0VkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZB0VkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:40:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbZB0VkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:40:07 -0500
Date: Fri, 27 Feb 2009 16:40:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@fifo99.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Don't profile branches in arm's boot decompressor
In-Reply-To: <1235769587.8233.1.camel@desktop>
Message-ID: <alpine.DEB.2.00.0902271638510.13395@gandalf.stny.rr.com>
References: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de> <1235769587.8233.1.camel@desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, Daniel Walker wrote:

> On Fri, 2009-02-27 at 22:09 +0100, Uwe Kleine-K?nig wrote:
> > This fixes many compile errors for arch/arm/boot/compressed/misc.c of
> > the type:
> > 
> > 	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables
> 
> Why do you think this error showed up just in that one file? It looks
> like the branch tracer puts section tags on non-globals all over the
> kernel..

The problem was with the -Dstatic= in the CFLAGS of the boot parameters. 
Since the branch profiler requires a static variable in the section, this 
would simply fail. That was the issue, and the solution was to disable the 
branch profiler for the boot code. No need for it there anyway.

-- Steve

