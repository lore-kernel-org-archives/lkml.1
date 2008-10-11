Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYJKEy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYJKEy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYJKEyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:54:20 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1680 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYJKEyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:54:19 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2008 00:54:19 EDT
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: recv() hangs until SIGCHLD ?
Date: Fri, 10 Oct 2008 21:48:45 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEDNAFAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
In-Reply-To: <23165e010810100943ua84228cn2faa03a5eb59255@mail.gmail.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 10 Oct 2008 21:50:47 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 10 Oct 2008 21:50:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nicolas Cannasse wrote:

> In some rare cases, one (or several) threads are hanging in recv().
> Both lsof and ls /proc/<pid>/fd show that the socket used is in
> ESTABLISHED mode but when checking on the host on which it's connected
> (a mysql DB) we can't find the corresponding client socket (as it's
> been closed already on the other side).

Blocking sockets will block until data is received. If no other thread is
sending data, this can block forever.

> We are using the Boehm GC which uses the signals SIGXCPU and SIGPWR to
> pause+restart the threads when running a GC cycle. We are correctly
> handling EINTR in send() and recv() by restarting the call in case
> they get interrupted this way.
>
> However, when attaching GDB to our locked thread it seems that even
> when the GC runs, recv() does not exit (the breakpoint after it is not
> reached). If we send SIGCHLD to the hanging thread with GDB, recv()
> does exit and the thread is correctly unlocked. If we don't, it will
> hang forever.

Why shouldn't it hang forever? What was supposed to wake it that's not?

> Any idea how we can stop this from happening or what additional things
> we can check to get more informations on what's occurring ?

You say a thread is hanging in receive and not returning. But you've yet to
explain why it should return. Was it interrupted by a signal? Was data
received? Is the socket non-blocking? Why isn't this expected behavior?
Blocking sockets block, full stop.

DS


