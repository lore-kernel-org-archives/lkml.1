Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbXIZTMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbXIZTMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbXIZTMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:12:10 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51397 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbXIZTMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:12:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18170.44782.134750.907938@alkaid.it.uu.se>
Date: Wed, 26 Sep 2007 21:11:42 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "John Z. Bohach" <jzb2@aexorsyst.com>, linux-kernel@vger.kernel.org
Subject: Re: __kernel_vsyscall () hangs in SIGCHLD handler
In-Reply-To: <a36005b50709261003j923835fu621882c54706d476@mail.gmail.com>
References: <200709260757.20478.jzb2@aexorsyst.com>
	<a36005b50709261003j923835fu621882c54706d476@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper writes:
 > On 9/26/07, John Z. Bohach <jzb2@aexorsyst.com> wrote:
 > > Is there some reason that syslog() sleeps in __kernel_vsyscall() when
 > > invoked from a signal handler?
 > 
 > Only very few functions are allowed to be called from signal handlers.
 >  This is clearly spelled out in the POSIX spec.  Section XSH 2.4.3
 > lists the allowed functions.  syslog of course is not on it.

The Linux kernel itself imposes no restrictions on what you can
do in user-space signal handlers.

However, user-space is a different story. The interrupted thread
may have held a lock, in which case calling code from the signal
handler that tries to take the same lock may result in a deadlock.
Or the thread may be been in the process of updating some private
data, in which case calling code from the signal handler that tries
to access that data may result in data corruption. And then there's
libc which may wrap your signal handler with code doing unspecified
libc magic. And so on, the possibilities for failure are endless :-)
