Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZCUOof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZCUOof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZCUOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:44:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:7005 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbZCUOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q6RL1YJNA3+KxE3fI54YbtX210QNugvIUDm2KtUeI9aaBU5wOeHgpgq488CpggT7vJ
         019L5O/NCgXKCHp3AItHLZ++XcTvw4LhlfFKs2ebYqqX2ueBxZMaR7gq1U3TjLIUGZBf
         aqatjn5ilGWSBctwU2Z6vDW001Ii5vSbVHEyk=
Message-ID: <49C4FD41.4030504@googlemail.com>
Date: Sat, 21 Mar 2009 15:44:17 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: ptrace performance (was: [Bug #12208] uml is very slow on 2.6.28
 host)
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.c1H.2PCvJB@chimera>
In-Reply-To: <qm8_cedJGaP.A.c1H.2PCvJB@chimera>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disclaimer: I'm not using UML, but these problems may be related.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> Subject		: uml is very slow on 2.6.28 host
> Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> Date		: 2008-12-12 9:35 (93 days old)
> References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4

The other day I noticed a dramatic ptrace slowdown between 2.6.27 and
2.6.28.x (verified with 2.6.28.8). In particular, a command like

	dd if=/dev/zero of=/dev/null bs=1024k count=1024

will normally report a throughput in the GB/s range. On 2.6.27, this is
also true if you run

	strace -o /dev/null <dd command as above>

which is only a little slower. But if I do the same on 2.6.28.x, I get a
throughput of about 100 MB/s or less, i.e. less than 10%. I tried the
commands on three different machines (an Athlon64 3000+, a Core Duo
T2400 and an Atom 330), and they all behave similar. The more system
calls a program uses, the worse the slowdown (try the dd command with
bs=16k and count=65536, for example - but don't hold your breath).

Interestingly, the CPUs are mostly idle while the command is executing
on 2.6.28.x, but there is a high (system) load on 2.6.27. Therefore, I
suspect that it's a scheduling or maybe timer problem that was
introduced between 2.6.27 and 2.6.28. I haven't had the time to check
the rc kernels yet; perhaps someone else can run a quick check to verify
that it's gone in the latest 2.6.29-rc.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
