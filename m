Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXEZBf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXEZBf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 21:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXEZBfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 21:35:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbXEZBfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 21:35:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current utrace breaks UML
In-Reply-To: Jeff Dike's message of  Wednesday, 23 May 2007 08:19:02 -0400 <20070523121902.GA4365@c2.user-mode-linux.org>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20070526013513.E894D1F8511@magilla.localdomain>
Date: Fri, 25 May 2007 18:35:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> UML, obviously.  Below is a smaller test.  orig_eax is wrong, so you
> can't read the system call number from the process.

Oops!  I overlooked the need to preserve the orig_eax value, though its
necessity is obvious.  This makes me wonder about those previous
reports that UML was working OK.

I refined the test case a little and that's in
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241408

I've fixed this in the latest utrace patch set.  I also wired up
sysemu on x86_64.  This means 32-bit processes calling ptrace now
support it for full compatibility with native i386, which the vanilla
kernel does not.  It also means it works for 64-bit ptrace calls,
whether operating on a 64-bit or a 32-bit target process.


Thanks,
Roland
