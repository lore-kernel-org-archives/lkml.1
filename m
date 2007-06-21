Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXFUQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXFUQFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFUQFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:05:17 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:45539 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbXFUQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:05:15 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 12:05:15 EDT
From: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Date: Thu, 21 Jun 2007 17:55:16 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH] signed binaries support [0/4]
Message-ID: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We (two students of CS) built a system for signing binaries and verifying them
before executing. Our main focus was to implement a way to inhibit execution
of suid-binaries, which are not trustworthy (i.e. not signed). Of course this
can also be used to grant other access rights, capabilities, etc.

The signature (e.g. HMAC-SHA1 with a shared secret) is stored in extended
filesystem attributes (userland-signing-tool provided) [1]. Depending on the
outcome of our check (performed during exec) a newly introduced flag in
the task_struct is set. To be able to also check libraries, we introduced a
similar flag in the vm_area struct. Depending on the state of the flag, the
suid/sgid bit on the file is honored or ignored. If a process behaves badly
(e.g mapping executable memory writable or loading an untrusted library) it
is handled appropriately (killed in our current implementation).

In the current state our code is of course very expermimental and should be
handled with care.

We mainly seek comments, suggestions and wisdom before we tackle the more
difficult tasks, like proper signatures (public-key-systems, etc.).

regards,
	Johannes

[1] http://git.informatik.uni-erlangen.de/?p=ssuid-userland&a=snapshot;h=HEAD

-- 
Johannes Schlumberger                      Department of Computer Science IV
Martensstrasse 1  D-91058 Erlangen Germany  University of Erlangen-Nuremberg
             http://wwwcip.informatik.uni-erlangen.de/~spjsschl
