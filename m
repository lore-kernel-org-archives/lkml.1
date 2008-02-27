Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYB0Llh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYB0Llh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYB0Ll3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:41:29 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38845 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYB0Ll1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:41:27 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] RUSAGE_THREAD
Date: Wed, 27 Feb 2008 17:11:55 +0530
User-Agent: KMail/1.9.4
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, vinay@linux.vnet.ibm.com,
       drepper@redhat.com
References: <200802051125.50423.sripathik@in.ibm.com> <47BF09DD.7090301@gmail.com>
In-Reply-To: <47BF09DD.7090301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271711.55530.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 23:13, Michael Kerrisk wrote:
> Sripathi Kodi wrote:
> > Hi Andrew,
> >
> > This adds the RUSAGE_THREAD option for the getrusage system call.
> > This is essentially Roland's patch from
> > http://lkml.org/lkml/2008/1/18/589, but the line about RUSAGE_LWP
> > line has been removed, as suggested by Ulrich and Christoph.
> >
> > Thanks,
> > Sripathi.
> >
> > This adds the RUSAGE_THREAD option for the getrusage system call.
>
> Sripathi,
>
> Could you write some small piece of text for the getrusage.2 man page
> that describes the intended behavior of RUSAGE_THREAD?

Michael,

Please take a look at the following patch to getrusage.2. This is the first
time I have edited a manpage, so I hope I have done it correctly!

Also, the RUSAGE_THREAD patch is currently in -mm, but not in mainline
yet. Hoping that it will make it, I have put a line in the patch that it is 
supported from 2.6.25 onwards.

Thanks,
Sripathi.

PS: I fixed spelling error in Ulrich's mail id in the CC list.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

--- getrusage.2.org	2008-02-27 17:00:57.000000000 +0530
+++ getrusage.2	2008-02-27 17:01:28.000000000 +0530
@@ -44,12 +44,22 @@ getrusage \- get resource usage
 .PP
 .BR getrusage ()
 returns current resource usages, for a \fIwho\fP
-of either 
+of 
+.B RUSAGE_THREAD, 
 .B RUSAGE_SELF
 or 
 .BR RUSAGE_CHILDREN .
-The former asks for resources used by the current process,
-the latter for resources used by those of its children
+.PP
+.B RUSAGE_THREAD 
+asks for resources used by the calling thread.
+.PP
+.B RUSAGE_SELF 
+asks for resources used by the current process, 
+which is the sum of resources used by all threads
+in the process.
+.PP
+.B RUSAGE_CHILDREN 
+asks for resources used by those of its children
 that have terminated and have been waited for.
 .PP 
 .in +0.5i
@@ -130,6 +140,9 @@ Since Linux 2.6, 
 and
 .I ru_nivcsw
 are also maintained.
+.PP
+.B RUSAGE_THREAD
+is supported only in Linux kernel versions 2.6.25 and above.
 .SH "SEE ALSO"
 .BR getrlimit (2),
 .BR times (2),
