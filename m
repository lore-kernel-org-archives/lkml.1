Return-Path: <linux-kernel-owner+w=401wt.eu-S1031132AbXFHTbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031132AbXFHTbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXFHTa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:30:56 -0400
Received: from [81.2.110.250] ([81.2.110.250]:53226 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181AbXFHTaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:30:55 -0400
Date: Fri, 8 Jun 2007 20:34:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Davide Libenzi <davidel@xmailserver.org>,
       Theodore Tso <tytso@mit.edu>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608203421.29fb9f15@the-village.bc.nu>
In-Reply-To: <4669A674.4080309@redhat.com>
References: <466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
	<20070608140150.6f31672f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	<20070608192652.4a291901@the-village.bc.nu>
	<4669A351.4010403@redhat.com>
	<20070608184650.GA4095@ftp.linux.org.uk>
	<4669A674.4080309@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We are talking about file descriptors here.  If you're using file
> descriptors as anything other than tokens you'll find out soon enough
> that your code is broken.  The new type of file descriptors cannot be
> used as indeces and the randomization makes sure that no program by some
> fluke happens to work.

If you are building a stable system and you test it and it passes
extensive testing you don't care if it works because of a specific
pattern of accesses since your testing shows that it continues to work.

If you randomize these it becomes fundamentally untestable. There is a
role for this in fuzz testing but there is not a role for it in normal
production behaviour.

Please consign the whole funky file handle farce to the bucket labelled
"dumb ideas". I know its a bit full but there is room in there for more -
unlike the kernel.

Alan
