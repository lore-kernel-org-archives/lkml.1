Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXCMOCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXCMOCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXCMOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:02:04 -0400
Received: from outbound3.mail.tds.net ([216.170.230.93]:42675 "EHLO
	outbound3.mail.tds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030302AbXCMOCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:02:03 -0400
Subject: Re: sys_write() racy for multi-threaded append?
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Bodo Eggert <7eggert@gmx.de>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070313022430.57503b08@lxorguk.ukuu.org.uk>
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it>
	 <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
	 <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	 <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	 <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 09:00:31 -0500
Message-Id: <1173794431.6729.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 02:24 +0000, Alan Cox wrote:
> > purports to handle short writes but has never been exercised is
> > arguably worse than code that simply bombs on short write.  So if I
> > can't shim in an induce-short-writes-randomly-on-purpose mechanism
> > during development, I don't want short writes in production, period.
> 
> Easy enough to do and gcov plus dejagnu or similar tools will let you
> coverage analyse the resulting test set and replay it.

You don't even need special tools: just change your code that says:

	foo = write(fd, mybuf, mycount);

to say (for example):

	foo = write(fd, mybuf, mycount / randomly_either_1_or_2);

Why would this need kernel support?  The average developer doesn't
really need to verify that the *kernel* works.  They just need to test
their own code paths - and in this case, they can see that foo is less
than mycount (sometimes).  The code paths don't care that it was not the
kernel that caused it.

- DML

