Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbYEBPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbYEBPeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbYEBPd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:33:57 -0400
Received: from web52010.mail.re2.yahoo.com ([206.190.48.26]:33903 "HELO
	web52010.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763658AbYEBPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:33:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=1plWGxn5OAvzUB4kxKykUpZju2p5UmTx6IiHT31Tv1N7xJaL/IwB6vvOzaUYbHm75CxDe0PW7gGbAscHBwJQCOB3AC/CIBRcRFUpcQ8pvNJEQz6fzXfjIoTe5+Ukubdg2l7TANaf8DG+pgn4Pa3kNSjF9FcXjNTZRwt0k8vwnj8=;
X-YMail-OSG: tQaPA30VM1nUKLaTpHrOgayxnTA91H5Iayd0Ju7I8nnZtHbhlxKkftGAT3iuagUc5XTWTe042uy58xgciOfKmbxkM85N5LniMcHtPuSY1QRxcxIHoOAI2pjqtw--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 08:33:50 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Re: [patch] fs: remove local variable copy of f_pos to enable thread-safe updates
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <342069.46185.qm@web52010.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message ----
> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Sent: Friday, May 2, 2008 12:33:02 PM
> Subject: Re: [patch] fs: remove local variable copy of f_pos to enable thread-safe updates
> 
> On Fri, May 02, 2008 at 02:14:25AM -0700, Matti Linnanvuori wrote:
> > From: Matti Linnanvuori 
> > 
> > Remove local variable copy of f_pos to enable thread-safe updates in
> > implementation functions of system calls read, readv, write and writev.
> 
> ... and we are back to square one with racy instances of ->read() that
> will use *pos twice, leaving a window for e.g. lseek() to invalidate
> e.g. wraparound tests.  Not that deciding what to do at the end of
> e.g. read() with lseek() happening in the middle would be fun anyway -
> esp. since you don't remember the kind of seek it had been.

File systems can be written so that implementations of read, lseek etc.
acquire a lock before using *pos, which precludes races. That was the
idea behind my patch. So, my patch does not necessarily cause races.
read instances can be racy in Linux now because there is no lock to
serialize read etc. system calls.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
