Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbYG3Ra5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbYG3Ra5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYG3Rar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:30:47 -0400
Received: from olsen.capsl.udel.edu ([128.4.10.3]:52898 "EHLO
	mail.capsl.udel.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYG3Raq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:30:46 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 13:30:46 EDT
Message-ID: <58212.83.235.174.162.1217437639.squirrel@webmail.capsl.udel.edu>
Date: Wed, 30 Jul 2008 13:07:19 -0400 (EDT)
Subject: [OT?] Can linux be compiled/used as a library?
From: venetis@mail.capsl.udel.edu
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: UDEL-ECECIS: Sanitizer.pm,v 1.64 2002/10/22 MIME-Version: 1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I assume that the first thing that comes to ones mind is "Why would
someone like to use an OS kernel as a library?". So let me explain my
situation.

I am using a simulator which runs on a x86 Linux system, which simulates
an Alpha processor. I have a cross-compiler for it to compile my programs.
There is, however, a disadvantage currently. System calls are not fully
simulated. How it works is as follows. The program sets up all required
simulated registers and executes the specific instruction that initiates
the system call. At this point the simulator takes over and uses the
necessary values from the simulated registers to execute the system call
NATIVELY, i.e., on the x86 Linux system. Finally, it writes the resulting
values returned from the system call back to the simulated registers and
execution continues. (Of course, some more book-keeping is required, but
this is the basic mechanism.)

Although this works, the problem is that system calls are not timed in the
simulator (execution time is thought of as zero). I have quite a few
programs where system call execution time is a considerable percentage of
the total execution time, which means that the reported execution time is
far from the "real" time required.

My thought was to completely remove the current system call simulation and
instead link the simulator with a real kernel (linux), which has been
compiled as a library for the simulated processor. This way, even system
calls would be timed and the reported time would be a much closer
estimation of the real time.

Any pointers and/or thoughts on this are appreciated.

Ioannis E. Venetis

P.S: Please CC any answers to me, as I am not subscribed to the list.

