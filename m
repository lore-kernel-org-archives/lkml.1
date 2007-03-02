Return-Path: <linux-kernel-owner+w=401wt.eu-S1423066AbXCBNH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423066AbXCBNH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423065AbXCBNH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:07:27 -0500
Received: from main.gmane.org ([80.91.229.2]:40123 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423064AbXCBNH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:07:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking =?utf-8?b?b2NjYXNpb25hbAl3cml0ZXJz?=
Date: Fri, 2 Mar 2007 13:06:30 +0000 (UTC)
Message-ID: <loom.20070302T140036-942@post.gmane.org>
References: <45DED819.9040404@hitachi.com>  <17888.14958.85897.289141@gargle.gargle.HOWL>  <45E380DA.6090509@hitachi.com>   <loom.20070301T133046-12@post.gmane.org> <1172826980.9640.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.150.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20060601 Firefox/2.0.0.2 (Ubuntu-edgy))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm sorry to piggy-back this thread.
> 
> Could it be what I'm experiencing in the following bugzilla report:
> http://bugzilla.kernel.org/show_bug.cgi?id=7372
> 
> As I explained in the report, I see this issue only since 2.6.18.
> So if your concern is related to mine, what could have changed between
> 2.6.17 and 2.6.18 related to this?

I don't think it's 2.6.x related, it's been under the sheets from start.

Related to your problem in the 7372 bug:

Pages are kept in memory for re-use, which is fast and fine except for:
1) data without re-use value or even single use
2) applications _do not_ advise the kernel how to cache pages related
   to there self generated i/o. POSIX does provide mechanisms to
   properly do so. But the kernel should help these poor apps.

To minimize your MySQL backup cp(1) problem, try this workaround:

cat ./cp_direct.sh 
#!/bin/sh
dd if=$1 of=$2 bs=1M iflag=direct oflag=direct

Combine this with [/etc/sysctl.conf]:

vm.vfs_cache_pressure = 1
vm.dirty_ratio = 2
vm.dirty_background_ratio = 1

This should reduce both the stress on the vm and response latency during
interactive work.

--
Leroy

