Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYHDMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYHDMr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYHDMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:47:49 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:55739 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYHDMrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:47:48 -0400
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org
Subject: sysrq+t doesn't work for some threads
Date: Mon, 4 Aug 2008 14:47:46 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041447.47172.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I need to debug a lustre problem, where lustre threads take 100% cpu time and 
also have a memory leak. The problem is, that sysrq+t doesn't work for these 
threads. It nicely shows all stack traces, just the trouble some threads 
won't show their traces:

[69338.858825] ll_mdt_36     R  running task       0 21679      2 (L-TLB)
[69338.865689] ll_mdt_37     S 0000000000000000     0 21680      2 (L-TLB)
[69338.872676]  ffff8102e6d01dd0 0000000000000046 ffffffff88160325 
00000000ffffffed
[69338.880544]  0000000000000000 ffffffff8815e016 000000000000000a 
ffff810322ef4ea0
[69338.888318]  ffff81031e7477b0 00003f0797609cef 000000000003434e 
ffff810322ef5050
[69338.895957] Call Trace:
[69338.898787]  [<ffffffff8828cab5>] :ptlrpc:ptlrpc_main+0xa55/0x1ce0
[69338.905297]  [<ffffffff8020a2f8>] child_rip+0xa/0x12


But I really need to have the trace of ll_mdt_36, which is one of the 
troublesome threads. Might this be a problem of the x86_64-mm-unwinder.patch 
we always apply since it provides much better traces?
This is with 2.6.22.19.

Any help would be appreciated.


Thanks,
Bernd

PS: Going to apply kdb now, maybe I get traces when I stop the system with 
kdb.


-- 
Bernd Schubert
Q-Leap Networks GmbH
