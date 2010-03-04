Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0CDJr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:47:56 -0500
Received: from mail.agmk.net ([91.192.224.71]:54824 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab0CDJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:47:55 -0500
X-Greylist: delayed 1508 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 04:47:54 EST
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: restrict initial stack space expansion to rlimit - the process
 killer...
References: <op.u8zxvxnpzipv1w@pawels.alatek.krakow.pl>
Date: Thu, 04 Mar 2010 10:22:40 +0100
To: linux-kernel@vger.kernel.org
Cc: mikey@neuling.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
Message-ID: <op.u81dn2i8zipv1w@pawels.alatek.krakow.pl>
In-Reply-To: <op.u8zxvxnpzipv1w@pawels.alatek.krakow.pl>
User-Agent: Opera Mail/10.10 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

i'm currently testing the 2.6.32.9 and observing random process killing
on my builder machine (x86-64) which contains several tcl/bash
scripts for svn checkout, compilation, archive and ftp deploying.

here's a fragment of build log:

(...)
[CXX] obj-release-i486-gnu-linux/genMappingRst.o
[CXX] obj-release-i486-gnu-linux/otelloVerdiThread.o
i486-gnu-linux-g++: Internal error: Killed (program as)
Please submit a full bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[1]: *** [obj-release-i486-gnu-linux/genMappingRst.o] Error 1

the builder process tree looks like this:

$ pstree -Acl
?---screen-+-bash---loop.sh-+-loop.sh---tclsh8.4---temp_9_12676174---tclsh8.4---temp_3_12676174---tclsh8.4---temp_4_12676174---tclsh8.4---temp_9_12676176---make---make-+-sh---ccache---x86_64-gnu-linu-+-as
              |
|
|                               `-cc1plus
              |
|
`-sh---ccache---x86_64-gnu-linu-+-as
              |
|
`-cc1plus
              |                `-tee
              `-bash---pstree


as you can see there're few levels of bash and tclsh(8.4)
and make/ccache/binutils/g++ workers at the bottom.

i've noticed that rolling back to the 2.6.32.8 (or just reverting
the 'ulimit -s' commit: 35e2093d5d7b632c083af3578c05876375828314)
fixes the problem.

so, is it my stack ulimit (8192) to small, or maybe the new limit
calculations are wrong? shoud i bump the stack limit for new kernels?

please CC me on reply.

BR,
Pawel.
