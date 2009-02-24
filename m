Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbZBXW7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbZBXW7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZBXW7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:59:39 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59716 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZBXW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:59:39 -0500
Date: Tue, 24 Feb 2009 22:59:30 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>
Subject: Re: [REGRESSION] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090224225930.GA3745@silver.sucs.org>
References: <20090221153822.GA4571@silver.sucs.org> <20090223223226.GA23763@silver.sucs.org> <200902240844.09424.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902240844.09424.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 08:44:09AM -0800, Jesse Barnes wrote:
> Can you get a backtrace of the hung process, maybe by logging in from another 
> machine and using gdb on the Xorg process?

(Done via sleep 30s; gdb.sh where gdb.sh contained the following:
gdb -batch-silent \
-ex 'set logging overwrite on' \
-ex "set logging file /tmp/gdb.log" \
-ex 'set logging on' \
-ex 'handle SIG33 pass nostop noprint' \
-ex 'set pagination 0' \
-ex 'run' \
-ex 'backtrace full' \
-ex 'info registers' \
-ex 'thread apply all backtrace' \
-ex 'quit' \
-p `pidof X` < /dev/null
< /dev/null

Xorg never seems happy after the above finishes and always wedged itself
after the script ran)

(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
[Thread debugging using libthread_db enabled]
[New Thread 0xb7ccea30 (LWP 2972)]
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)

Program received signal SIGUSR1, User defined signal 1.
[Switching to Thread 0xb7ccea30 (LWP 2972)]
0xb7fe8424 in __kernel_vsyscall ()
#0  0xb7fe8424 in __kernel_vsyscall ()
No symbol table info available.
#1  0xb7e3984d in select () from /lib/tls/i686/cmov/libc.so.6
No symbol table info available.
#2  0x081b22e5 in WaitForSomething ()
No symbol table info available.
#3  0x0808d69d in Dispatch ()
No symbol table info available.
#4  0x0807471b in main ()
No symbol table info available.
eax            0xfffffdfe	-514
ecx            0x820a240	136356416
edx            0x0	0
ebx            0x100	256
esp            0xbf902cc0	0xbf902cc0
ebp            0xbf902f58	0xbf902f58
esi            0x0	0
edi            0xbf902f40	-1081069760
eip            0xb7fe8424	0xb7fe8424 <__kernel_vsyscall+16>
eflags         0x3246	[ PF ZF IF #12 #13 ]
cs             0x73	115
ss             0x7b	123
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x33	51

Thread 1 (Thread 0xb7ccea30 (LWP 2972)):
#0  0xb7fe8424 in __kernel_vsyscall ()
#1  0xb7e3984d in select () from /lib/tls/i686/cmov/libc.so.6
#2  0x081b22e5 in WaitForSomething ()
#3  0x0808d69d in Dispatch ()
#4  0x0807471b in main ()
The program is running.  Exit anyway? (y or n) [answered Y; input not from terminal]

-- 
Sitsofe | http://sucs.org/~sits/
