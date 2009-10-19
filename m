Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZJSIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZJSIwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZJSIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:52:34 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:40674 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbZJSIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:52:34 -0400
X-Greylist: delayed 2477 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 04:52:34 EDT
From: Michael Cree <mcree@orcon.net.nz>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Unimplemented syscalls on Alpha
Date: Mon, 19 Oct 2009 21:11:07 +1300
Message-Id: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.6.3.3
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 19 Oct 2009 21:11:20 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Oct 19 21:11:21 2009
X-DSPAM-Confidence: 0.7616
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't but help notice the increasing number of unimplemented syscalls
on the Alpha architecture.  I thought I might poke around to see what might
be required to get these implemented and got a pleasant surprise when it
seems some only need an entry in the syscall table.  Indeed, the patch in
reply to this message gets preadv and pwritev going -- tested with the
sample program at http://lkml.org/lkml/2009/4/6/535.

I am happy to write patches to wire up more of the syscalls, but I am
wondering which ones are as straightforward as the preadv/pwritev case?
That is, do any require extra programming other than the syscall table?  Do
I need to get the entries in the syscall table in the same order as other
architectures?

The unimplemented syscalls on Alpha are:

<stdin>:395:2: warning: #warning syscall umount2 not implemented
<stdin>:1463:2: warning: #warning syscall timerfd_create not implemented
<stdin>:1471:2: warning: #warning syscall fallocate not implemented
<stdin>:1475:2: warning: #warning syscall timerfd_settime not implemented
<stdin>:1479:2: warning: #warning syscall timerfd_gettime not implemented
<stdin>:1483:2: warning: #warning syscall signalfd4 not implemented
<stdin>:1487:2: warning: #warning syscall eventfd2 not implemented
<stdin>:1491:2: warning: #warning syscall epoll_create1 not implemented
<stdin>:1495:2: warning: #warning syscall dup3 not implemented
<stdin>:1499:2: warning: #warning syscall pipe2 not implemented
<stdin>:1503:2: warning: #warning syscall inotify_init1 not implemented
<stdin>:1507:2: warning: #warning syscall preadv not implemented
<stdin>:1511:2: warning: #warning syscall pwritev not implemented
<stdin>:1515:2: warning: #warning syscall rt_tgsigqueueinfo not implemented
<stdin>:1519:2: warning: #warning syscall perf_event_open not implemented

Cheers
Michael.

