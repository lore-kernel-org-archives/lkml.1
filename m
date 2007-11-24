Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbXKXSbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbXKXSbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXKXSay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:30:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXKXSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:30:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Date: Sat, 24 Nov 2007 19:48:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>
References: <20071124175112.58193424@morte>
In-Reply-To: <20071124175112.58193424@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711241948.58881.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 24 of November 2007, Stefano Brivio wrote:
> It looks like the jiffies counter sometimes jumps back and forth of some
> hundreds seconds in 2.6.24-rc3. I observed that this happens when I use the
> su(1) command, e.g.:
> 
> Nov 24 06:17:17 morte [190769.065301] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 232 (6730/29)
> Nov 24 06:17:22 morte su[16826]: Successful su for root by st3
> Nov 24 06:17:22 morte su[16826]: + pts/1 st3:root
> Nov 24 06:17:22 morte su(pam_unix)[16826]: session opened for user root by (uid=1000)
> Nov 24 06:17:38 morte [715682.606983] b43-phy2 ERROR: PHY transmission error
> Nov 24 06:18:17 morte [715707.765415] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 194 (970/5)
> 
> or
> 
> Nov 23 20:55:40 morte [627074.320296] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 10 (550/55)
> Nov 23 20:56:01 morte su[5452]: Successful su for root by st3
> Nov 23 20:56:01 morte su[5452]: + pts/4 st3:root
> Nov 23 20:56:01 morte su(pam_unix)[5452]: session opened for user root by (uid=1000)
> Nov 23 20:56:03 morte su(pam_unix)[5452]: session closed for user root
> Nov 23 20:56:40 morte [167187.102931] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 10 (40/4)
> 
> or
> 
> Nov 23 06:31:00 morte [156536.124549] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 240 (6480/27)
> Nov 23 06:31:58 morte su[4350]: Successful su for root by st3
> Nov 23 06:31:58 morte su[4350]: + pts/0 st3:root
> Nov 23 06:31:58 morte su(pam_unix)[4350]: session opened for user root by (uid=1000)
> Nov 23 06:32:09 morte [587438.574530] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 240 (4080/17)
> 
> (I checked with a clock the timestamp prepended by syslog-ng, and it's
> correct.)
> 
> I'm thinking this could be somehow related to the setpriority() call made
> by su(1), but I don't know how to debug this further. Any clue?

NO_HZ?  Highres timers?

I understand that the previous kernels behave correctly.  All of them?

Rafael
