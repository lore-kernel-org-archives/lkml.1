Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZKFXKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZKFXKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbZKFXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:10:47 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:54307 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZKFXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:10:47 -0500
Message-ID: <4AF4ACBE.5030005@nortel.com>
Date: Fri, 06 Nov 2009 17:09:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: simultaneous signal handling and setjmp/longjmp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2009 23:10:49.0929 (UTC) FILETIME=[6154A390:01CA5F36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a bit of an odd hypothetical question dealing with signals and
setjmp/longjmp.

Suppose we have an app with multiple signals pending.  (Say, SIGALRM and
SIGSEGV.)  In the signal handler for SIGSEGV, we're going to call call
longjmp().  (Yes, I'm aware of the issues.)

At this point we're still in the kernel and both SIGSEGV and SIGALARM
are pending. What happens?

If we run the SIGSEGV handler does the SIGALARM stay pending until the
segfault handler completes?  What happens when the segfault handler
calls longjmp()?  Does the SIGALARM handler get called on the logical
return from sigsetjmp(), and if so how does that happen since the glibc
code for setjmp/longjmp doesn't seem to call any kernel syscalls?

Thanks for any information you can provide...

Chris
