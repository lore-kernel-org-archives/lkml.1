Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZK3QhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZK3QhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZK3QhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:37:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58091 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZK3QhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=C2qTKOOvo6rgtAgRBl+D4EvNLvKvErAuFbGlxVwl45L08MmQIUDiJH9bwELYYeIDyZ
         4CWrTgJ9WmytrziooleAPkCWo5T6bLQzkbB34z11kTRlMnIOqFugFyE4wD2OVb+pBKM5
         sDoQMVmqZtEcJ3paqQqzKr514pYEwDFcf2CQo=
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 30 Nov 2009 08:37:04 -0800
Message-ID: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com>
Subject: using kernel headers in libc headers
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel headers nowadays are cleaned up to separate in-kernel
definitions from those that are exported.  That's of course good but
it's unfortunately not sufficient to use (most of) the headers in
glibc.

Take <linux/sched.h> for instance.  The <sched.h> header is defined in
POSIX and therefore the specify which symbols can be defined in which
configuration.  The <linux/sched.h> defines all kinds of symbols,
though, unconditionally.  If you compare it with the glibc header
you'd see that all the CLONE_* symbols and some of the SCHED_* symbols
are only defined in certain configurations (non-POSIX configurations).

It's likely in everybody's interest to get the kernel headers used.
But for this mode #ifdefs are needed.  I'm willing to do the work.
Easy enough to do when I'm going through the headers one-by-one to
enable them in glibc.  But I don't want to start this work unless it's
going to be accepted.  The symbols would be something like

  __USE_MISC

or

  __USE_GNU

These are not macros which the user must define.  The user sets macros
like _GNU_SOURCE etc which then set all the appropriate __USE_* macros
(see "info libc 'Feature Test Macros'" on machines with glibc
installed).  These names are somewhat glibc-specific but other libcs
can (or already have) adapt them.

So, what do you say?
