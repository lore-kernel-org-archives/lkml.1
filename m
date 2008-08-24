Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYHXWaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYHXWaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHXWaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:30:04 -0400
Received: from main.gmane.org ([80.91.229.2]:46681 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYHXWaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:30:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Reproducible rRootage segfault with 2.6.25 and above (regression?)
Date: Sun, 24 Aug 2008 23:29:26 +0100
Message-ID: <g8sncp$8us$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.113.19.113.plusnet.pte-ag1.dyn.plus.net
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found that when running certain levels in the game rRootage on 
kernels later than 2.6.24 a segfault will be caused. This segfault is 
not there on 2.6.24 (and below) though...

Frustratingly I have been unable to bisect my way to the kernel change 
because I hit a USB timeout issue bisecting between 2.6.24-2.6.25 which 
made booting impossible. Further it seems there are a number of 
conditions that need to be met before the problem manifests itself:

1. Compiler optimisation used to compile rRootage must be -O1 or higher 
(-Os also triggers the problem)
2. The running kernel (going by release) must be 2.6.25 or later.
3. The gcc used to compile the game must (seemingly) not be 3.3 (using 
4.2 shows the problem. Other versions may also show up the problem).
4. Not every level in every mode will show the problem (it seems linked 
to certain patterns). I have found level 9A in the green "GigaWing" mode 
is usually quick to trigger the issue but you may have to kill the first 
enemy once to see the problem (if you can just get to even that part it 
is likely the problem is non present).

I have seen the issue on a range of 2.6.25+ kernels (both hand compiled 
on openSUSE kernels and a pre-shipped 2.6.26-5 from Ubuntu 8.10).

The segfault in question is due to an array being accessed beyond its 
bounds (the array sctbl on this line 
http://www.koders.com/cpp/fid93F842B399CA68D754CADEC374AE934EED72C07D.aspx#L246 
). Running the game under valgrind on a 2.6.24 kernel did not generate 
any  warnings about that array (using MALLOC_CHECK_=2 didn't generate 
any warnings either). The problem has been reproduced on two different 
machines (a Thinkpad T60 and an eeePC).

Finally, this also afflicts a prebuilt binary from 2004 (which probably 
wasn't built using gcc4.x 
http://sourceforge.net/project/showfiles.php?group_id=112441 ).

The issue is fiddly but reproducible. All help in pinpointing the 
problem source is appreciated.

-- 
Sitsofe | http://sucs.org/~sits/

