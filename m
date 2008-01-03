Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYACQDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYACQDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYACQC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:02:59 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:44881 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYACQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:02:59 -0500
Date: Thu, 03 Jan 2008 17:02:56 +0100
Message-Id: <83883214@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18um+FAjrGWQbYWrc0oiHQDv2S/+AGdDsa2iwksPTl+m3/Kj
 MI2qw8WTel71bWsSZ3CK3dWJcAa0YhOf+s1hfYHmubYtSCEWBE=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This errno is so out of place.
yes, that was stupid.

anyway:

# strace ./mytiocons
--snipp--
open("/dev/ttyS0", O_RDWR)              = 3
ioctl(0, TIOCCONS)                      = -1 EBUSY (Device or resource busy)
ioctl(3, TIOCCONS)                      = -1 EBUSY (Device or resource busy)
--snipp--

man tty_ioctl is telling:

Redirecting console output

TIOCCONS      void
    Redirect output that would have gone to
    /dev/console or /dev/tty0 to the given tty. If that was a pty master, send it to the slave. Anybody can do this as long as the output was not redirected yet. If it was redirected already EBUSY is returned, but root may stop redirection by using this ioctl with fd pointing at /dev/console or /dev/tty0.



but it doesn`t seem to make any difference if i do that ioctl on /dev/console or /dev/tty0 , because i`m getting EBUSY there, too


> 
> 
> On Jan 3 2008 15:39, devzero@web.de wrote:
> >fantastic, thanks!
> >
> >unfortunately......
> >
> >opensuse103:/home/roland/serialcons # ./mytioccons
> >ioctl: Device or resource busy
> >
> >but i`m not deep enough into programming to understand this.
> >
> 
> >int main(void)
> >{
> >int fd = open("/dev/ttyS0", O_RDWR);
> >int errno;
> 
> This errno is so out of place.
> 
> >
> >ioctl(0, TIOCCONS, NULL);
> >
> >if (ioctl(fd, TIOCCONS, NULL) < 0)
> >        printf("ioctl: %s\n", strerror(errno));
> >}
> 


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

