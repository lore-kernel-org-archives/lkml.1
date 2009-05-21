Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZEUWQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZEUWQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZEUWP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:15:56 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:53618 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbZEUWPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:15:55 -0400
Subject: Allow signaling a process by all its thread ids?
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jean-Paul Calderone <exarkun@twistedmatrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 May 2009 00:16:19 +0200
Message-Id: <1242944179.10298.11.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug report at https://bugs.launchpad.net/bugs/341239 where
the question is asked. Should it be possible to signal a process with
kill(2) by passing any of the thread ids belong to the process as
argument to kill?

Current behaviour allows that but the reporter argues that it shouldn't
be allowed by the following argument:

"I'm no expert in interpreting POSIX.  A casual (but careful) reading of
POSIX 1003.1-2004 suggests that this isn't the intended behavior.  It is
implied in a few places, most notably the getpid[1] documentation, that
a process has only one PID (by use of the definite article when
referring to it - ie, "the process ID").  The kill function[2] operates
on "a process or a group of processes".  It sends a signal "to the
process whose process ID is equal to pid".  Combined with the previous
point, this suggests there should be only one process ID which can be
passed to kill to send a signal to a particular process.

It may be that POSIX is weakly worded enough that either allowing or
disallowing this behavior is valid.  I think that allowing it is a
violation of POSIX, but I can find no single, explicit, direct statement
in POSIX to back this up.

There is at least one other argument to disallow this behavior even if
it is not technically illegal.  Consider the traditional, widespread
convention of pid files.  This behavior drastically reduces their
utility, as it greatly increases the chance of PID collisions, a case in
which it is difficult to automatically (that is, without human
intervention) recognize that a pid file no longer corresponds to a
running process which created it.  This is the case in which I
encountered the behavior - when it repeatedly caused services not to
restart because they encountered a thread of another process and
misinterpreted it to mean the service was already running.

I hope this is convincing.  If not, what kind of argument would be?

[1]: http://www.opengroup.org/onlinepubs/009695399/functions/getpid.html
[2]: http://www.opengroup.org/onlinepubs/009695399/functions/kill.html"


Simon Holm Thøgersen

