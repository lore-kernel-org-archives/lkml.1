Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXG1WyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXG1WyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXG1WyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:54:01 -0400
Received: from gw.goop.org ([64.81.55.164]:50483 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbXG1WyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:54:01 -0400
Message-ID: <46ABC892.2060903@goop.org>
Date: Sat, 28 Jul 2007 15:52:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
 mode helper when core_pattern is a pipe
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net> <20070728161725.GA5836@piware.de> <20070728172142.GA10555@hmsreliant.homelinux.net>
In-Reply-To: <20070728172142.GA10555@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> Jeremy asked that I make a patch next week to address split_argv's requirement
> that the argc parameter be non-NULL.  I'll be fixing that next week, and what I
> can do is further enhance it such that it ignores spaces in quoted strings,
> which should address the case that concerns you.  I.E I can make split_argv
> behave such that:
> echo "|\"foo bar\" --pid %p" > /proc/sys/kernel/core_pattern
> results in the following argv:
> {{"foo bar"}, {"--pid"}, {"1234"}}
>
> Which I think handles what you are looking for.
>   

No, please don't.  My original argv_split did that, and it was just way
too complex.  If you need complex quoting, you can always point it at a
shell script and handle it there.

    J
