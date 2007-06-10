Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXFJC3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXFJC3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 22:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXFJC3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 22:29:44 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:45238 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXFJC3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 22:29:43 -0400
Date: Sat, 9 Jun 2007 19:29:42 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0706091923580.10324@twinlark.arctic.org>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nice.  i proposed something like this 8 or so years ago... the problem is 
that you've also got to deal with socket(2), socketpair(2), accept(2), 
pipe(2), dup(2), dup2(2), fcntl(F_DUPFD)... everything which creates new 
fds.

really what is desired is fork/clone with selective duping of fds.  i.e. 
you supply the list of what will become fd 0,1,2 in the child.

-dean
