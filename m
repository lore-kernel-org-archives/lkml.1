Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbXGVLjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbXGVLjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 07:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbXGVLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 07:39:16 -0400
Received: from web57705.mail.re3.yahoo.com ([68.142.236.59]:30781 "HELO
	web57705.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755079AbXGVLjP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 07:39:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=c3zW3Y2SlTyUvMOR627esEfBe0w74bdGB23LQtmrHDkexhCckbfZIXmsYj8q0daszhul+klmqxlGhPvbc7zinj8VBJjlbIe3ExjHIoy0PoZ8dWipqACvc/0fDS8UK8GjV8S1n07PFeDsh9PU2Nc7inkzI8SR66MsTDXaJIJFtHg=;
X-YMail-OSG: CXkGSscVM1lCqI3DIvSieM3og4BbjZC3qwGyzyWse2GiGxiWOW65urA7DkLT637Br6rRoAbliSzwbx0H1i0Rv6NXi6ggAcph3fuYzkAs2McOEsVPjC8UbIYKL5hpbsA8i9uwqG3BDB9taps-
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Sun, 22 Jul 2007 04:39:14 -0700 (PDT)
From: Jacob A <jacoba51-tmp@yahoo.com>
Subject: Re: 2.4 Q: list of open files per inode?
To: Al Viro <viro@ftp.linux.org.uk>, Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <259547.37103.qm@web57705.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

I'm using the open/close call as a way for processes to register/unregister with a watchdog driver that I'm writing.
I thought that I can save the housekeeping within the driver, but it looks like It would be easier just to maintain my own list
and be done with it.

Jacob

----- Original Message ----
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jacob A <jacoba51-tmp@yahoo.com>; linux-kernel@vger.kernel.org
Sent: Thursday, July 19, 2007 7:38:10 PM
Subject: Re: 2.4 Q: list of open files per inode?

On Thu, Jul 19, 2007 at 01:41:03PM +0200, Jan Engelhardt wrote:
> 
> On Jul 19 2007 02:01, Jacob A wrote:
> >
> > How can a device driver go over the  list of all the files that are open on a
> > specific inode instance?
> 
> pseudo-code:
> 
> task_list_lock;
> for each process; do
>     lock_fdtable;
>     for each filedescriptor; do
>         do_something(fd->file_ptr);
>     unlock_fdtable;
> task_list_unlock;

Not again...

There are other things that can keep file open.  SCM_RIGHTS, references
held by syscall in progress, etc., etc.

The real question is why does driver want to do that?  Details, please...



