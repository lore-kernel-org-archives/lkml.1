Return-Path: <linux-kernel-owner+w=401wt.eu-S935971AbXGZTxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935971AbXGZTxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXGZTxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:53:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763880AbXGZTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:53:43 -0400
Date: Thu, 26 Jul 2007 12:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Woods <wwoods@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse
 arguments when pattern is a pipe
Message-Id: <20070726125240.645c3322.akpm@linux-foundation.org>
In-Reply-To: <1185478584.15670.31.camel@metroid.rdu.redhat.com>
References: <20070726173923.GA5701@hmsreliant.homelinux.net>
	<20070726114832.faf14bb0.akpm@linux-foundation.org>
	<1185478584.15670.31.camel@metroid.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 15:36:24 -0400 Will Woods <wwoods@redhat.com> wrote:

> On Thu, 2007-07-26 at 11:48 -0700, Andrew Morton wrote:
> > On Thu, 26 Jul 2007 13:40:19 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > > 	Currently, core dumps can be redirected to a pipe by placing the
> > > following string template in /proc/sys/kernel/core_pattern:
> > > |<path/to/application>
> > > This patch extends this ability, allowing the core_pattern to contain arguments
> > > to be passed as an argv array to the userspace helper application.  It also add
> > > a format specifier, %c, which allows the RLIM_CORE value of the crashing
> > > application to be passed on the command line, since RLIMIT_CORE is reduced to
> > > zero when execing the userspace helper
> > 
> > This all seems to be getting a bit nutty.  Who needs this feature
> > and what will they do with it, etc?
> 
> We're using it for doing a system-wide crash dump handler. Currently
> Ubuntu's using it with their Apport tool[1] for this purpose; I'm
> adapting that for Fedora. 

Can you please copy the relevant Ubuntu people on the patches then?  It
would be valuable to get their input on the proposal.

> The Ubuntu approach requires a kernel patch that adds a bunch of process
> information (process pid, RLIMIT_CORE, etc) to the environment of the
> crash handler[2]. Most of that information can instead be parsed out of
> the ELF headers - which is what I wrote code to do[3]. The problem that
> remains is determining the value of RLIMIT_CORE. (This is used to
> determine whether the user wants a normal corefile, thus retaining
> normal core dump behavior). 
> 
> As I understand it, getrlimit() won't return the correct values while
> dumping to a pipe. So we need to pass the original RLIMIT_CORE to the
> userspace helper somehow. It seems sensible to pass arguments to a
> userspace program by using argv[]. So there we are.

yup.  The changelog should clearly document this new kernel/userspace
interface, please.  Things like what the argv format will be, which args
are optional, etc.

> There's probably many other uses for this stuff but that's the specific
> one we're targeting. Does that make sense? If there's an easier way to
> get the original RLIMIT_CORE from inside the crash handler, I'd love to
> hear it.
> 

I'm still emerging from the "what the heck is this" state ;)

You need to tell us these things...
