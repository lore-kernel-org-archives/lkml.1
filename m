Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZEOT45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZEOT45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZEOT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:56:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52721 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZEOT4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:56:49 -0400
Date: Fri, 15 May 2009 21:56:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adam Langley <agl@google.com>
Cc: linux-kernel@vger.kernel.org, markus@google.com
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090515195644.GA1377@ucw.cz>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <396556a20805301217k293e5718h6bbf02b234897235@europa>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Briefly, it adds a second seccomp mode (2) where one uploads a bitmask.
> Syscall n is allowed if, and only if, bit n is true in the bitmask. If n
> is beyond the range of the bitmask, the syscall is denied.
> 
> If prctl is allowed by the bitmask, then a process may switch to mode 1,
> or may set a new bitmask iff the new bitmask is a subset of the current
> one. (Possibly moving to mode 1 should only be allowed if read, write,
> sigreturn, exit are in the currently allowed set.)
> 
> If a process forks/clones, the child inherits the seccomp state of the
> parent. (And hopefully I'm managing the memory correctly here.)

If you allow setuid exec here, you have added a security hole. Deny
setuid() to sendmail and have fun...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
