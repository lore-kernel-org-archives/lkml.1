Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXGZStf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXGZStf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbXGZStZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:49:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758156AbXGZStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:49:24 -0400
Date: Thu, 26 Jul 2007 11:48:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse
 arguments when pattern is a pipe
Message-Id: <20070726114832.faf14bb0.akpm@linux-foundation.org>
In-Reply-To: <20070726173923.GA5701@hmsreliant.homelinux.net>
References: <20070726173923.GA5701@hmsreliant.homelinux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 13:40:19 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:

> 	Currently, core dumps can be redirected to a pipe by placing the
> following string template in /proc/sys/kernel/core_pattern:
> |<path/to/application>
> This patch extends this ability, allowing the core_pattern to contain arguments
> to be passed as an argv array to the userspace helper application.  It also add
> a format specifier, %c, which allows the RLIM_CORE value of the crashing
> application to be passed on the command line, since RLIMIT_CORE is reduced to
> zero when execing the userspace helper

This all seems to be getting a bit nutty.  Who needs this feature
and what will they do with it, etc?

You have a few open-coded kstrdup()s in there, btw.  And an open-coded
free_argv_array() on the error path.  And a lot of checkpatch warnings.
