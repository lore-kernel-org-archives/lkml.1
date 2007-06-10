Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXFJSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXFJSVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXFJSVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:21:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbXFJSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:21:11 -0400
Date: Sun, 10 Jun 2007 11:19:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <466BC0E3.4050600@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0706101118500.20321@woody.linux-foundation.org>
References: <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com>
 <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <466BC0E3.4050600@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-291363542-1181499549=:20321"
Content-ID: <alpine.LFD.0.98.0706101119140.20321@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-291363542-1181499549=:20321
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.0.98.0706101119141.20321@woody.linux-foundation.org>



On Sun, 10 Jun 2007, Eric Dumazet wrote:

> Linus Torvalds a écrit :
> > 
> > 	close(0);
> > 	close(1);
> > 	close(2);
> > 	.. generate filenames, whatever ..
> > 	if (open(..) < 0 || open(..) < 0 || open(..) < 0)
> > 		die("Couldn't redirect stdin/stdout/stderr");
> > 
> > and there's absolutely nothing wrong with this kind of setup, even if you
> > could obviously have done it other ways too (ie by using "dup2()" instead of
> > "close + open"),
> 
> This kind of setup was OK 25 years ago, before multithreading era.
> You cannot reasonably expect it to work in a multithreaded program.

Who said _anything_ about threading?

The above is a totally non-threaded app. 99% of all applications are like 
that.

Threading is for the 1%. But 99% is what we need to make sure works.

		Linus
---1463790079-291363542-1181499549=:20321--
