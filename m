Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZA2Xma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZA2Xma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZA2XmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:42:21 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:37663 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbZA2XmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:42:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAD/LgUlMQWt2/2dsb2JhbACBbslshBAG
Date: Thu, 29 Jan 2009 18:42:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: LTTng 0.88 adds dynamic instrumentation support (kprobes)
Message-ID: <20090129234203.GA20044@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:22:36 up 28 days, 23:20,  4 users,  load average: 0.22, 0.07,
	0.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.88 and LTTV 0.12.9 now support dynamic kernel instrumentation
with kprobes through a simple /mnt/debugfs/ltt/kprobes/ interface.

Usage example :

ltt-armall
echo do_fork > /mnt/debugfs/ltt/kprobes/enable
lttctl -C -w /tmp/trace trace
(so something)
lttctl -D trace
lttv -m textDump -e event.name=kernel.kprobe -t /tmp/trace

Trace set contains 1 traces

kernel.kprobe: 2486.393516120 (/tmp/trace/kernel_2), 0, 0, , , 0, 0x0,
    MODE_UNKNOWN { ip = FFFFFFFF8023CDC0 }
kernel.kprobe: 2489.826739495 (/tmp/trace/kernel_2), 25527, 25527, bash,
    , 25526, 0x0, SYSCALL { ip = FFFFFFFF8023CDC0 [do_fork+0x0/0x3e0] }
kernel.kprobe: 2491.618955019 (/tmp/trace/kernel_6), 25527, 25527, bash,
    , 25526, 0x0, SYSCALL { ip = FFFFFFFF8023CDC0 [do_fork+0x0/0x3e0] }
End trace set

Enable, disable and list operations are availables to manipulate the
active LTTng kprobes.

LTTV 0.12.9 adds support to print the symbol names along with the
kprobes addresses.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
