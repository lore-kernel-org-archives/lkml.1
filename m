Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZH0SjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZH0SjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZH0SjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:39:12 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:45414 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZH0SjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:39:12 -0400
X-Originating-IP: [207.115.11.160]
From: heitkamp@ameritech.net
To: Andreas Schwab <schwab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: popen2 popen call
Date: Thu, 27 Aug 2009 18:39:13 +0000
Message-Id: <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net>
In-Reply-To: <m3prahctv6.fsf@hase.home>
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org>
 <m3prahctv6.fsf@hase.home>
X-Mailer: AT&T Message Center Version 1 (Mar  2 2009)
X-Authenticated-Sender: aGVpdGthbXBAYW1lcml0ZWNoLm5ldA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------------- Original message from Andreas Schwab <schwab@redhat.com>: -------------- 


> "F. Heitkamp" writes: 
> 
> > When the popen call is made in sshd/session.c I get a error from 
> > strerror of "Function not Implemented". 
> 
> Which function exactly returns this error? 

In the openssh source distribution there is a file, session.c that uses popen, with the
ultimate purpose of fixing the .Xauthority file for X11 forwarding.  It uses popen to set the DISPLAY, MIT-MAGIC-COOKIE etc. via the shell I think, executing xauth.  In session.c popen is used three times under different conditions.  I put strerror calls where the popen call returns a NULL pointer to try to find out why the popen call fails.  I could post the section of code if you want to see.  I am not a professional programmer.

The gist of it is:

fp = popen( cmdstr, "w" );
if ( !fp )
  /* call strerror, errno */
> 
> There is no such thing as a popen2 syscall. 

OK.  I read in one of the messages, that glibc, passes the popen call to a ABI in the kernel. I have not looked at the code in glibc yet.

Fred

