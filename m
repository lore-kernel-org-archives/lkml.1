Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZAYK7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZAYK7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZAYK7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:59:10 -0500
Received: from mail.enyo.de ([212.9.189.167]:60531 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZAYK7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:59:09 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
       team@security.debian.org, libpam-modules@packages.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
References: <20090121115219.GA2754@anguilla.noreply.org>
	<8763k5u3xs.fsf@mid.deneb.enyo.de>
	<497A3E62.6010706@caviumnetworks.com>
Date: Sun, 25 Jan 2009 11:59:06 +0100
In-Reply-To: <497A3E62.6010706@caviumnetworks.com> (David Daney's message of
	"Fri, 23 Jan 2009 14:02:10 -0800")
Message-ID: <87fxj74pol.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Daney:

> One problem is that for values of RLIMIT_NOFILE less than something
> like 4096, it is much faster to call sys_close() on all possible
> values than iterate through a handful of open files from /proc/self/fd
> using opendir(3)/readdir(3).

Really?  Yuck.

> The real solution is to convert your user space programs to use the
> new syscalls that allow for race-free setting of close-on-exec.
> Then you no longer need to mess around with iterating over these
> things.

These system calls are too recent to use in the next two Debian
releases.  In addition, we can't really be sure that all libraries use
the new calls.

I find the design of the CLOEXEC business somewhat revulsive, by the
way.  It reminds me of those DoSomethingEx APIs in another platform.
The *_at system calls are a similar wart.  Even with this stuff, I
still can't safely open a file with a different effective user ID in a
multithreaded application, or create a AF_UNIX socket with specific
file system permissions.  Some thread-specific context with what have
been traditionally considered per-process attributes might have been
better. 8-(
