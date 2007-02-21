Return-Path: <linux-kernel-owner+w=401wt.eu-S1422653AbXBUQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422653AbXBUQXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422661AbXBUQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:23:47 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:57008 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422653AbXBUQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:23:47 -0500
Date: Thu, 22 Feb 2007 01:23:56 +0900 (JST)
Message-Id: <20070222.012356.27907445.yoshfuji@linux-ipv6.org>
To: linux-kernel@vger.kernel.org
Subject: request_module: runaway loop modprobe net-pf-1 (is Re: Linux
 2.6.21-rc1)
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> (at Tue, 20 Feb 2007 20:53:45 -0800 (PST)), Linus Torvalds <torvalds@linux-foundation.org> says:

> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
> name it), ACPI updates, and lots of driver work. And just a lot of 
> cleanups.

I cannot boot 2.6.21-rc1; it falls into OOM-Killer.

Interesting error message I can see is:
   request_module: runaway loop modprobe net-pf-1

After bisecting, the commit
  Driver core: let request_module() send a /sys/modules/kmod/-uevent
(id c353c3fb0700a3c17ea2b0237710a184232ccd7f) is to blame.

Reverting it fixes the issue to me.

Regards,

--yoshfuji
