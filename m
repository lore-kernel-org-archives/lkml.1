Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXKGPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXKGPQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXKGPQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:16:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXKGPQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:16:08 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Yuichi Nakamura <ynakam@hitachisoft.jp>
Subject: Re: [patch] audit support for SH
Date: Wed, 7 Nov 2007 10:15:33 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       lethal@linux-sh.org, Al Viro <aviro@redhat.com>
References: <20071107135743.C1BD.YNAKAM@hitachisoft.jp>
In-Reply-To: <20071107135743.C1BD.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071015.33765.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 12:04:46 am Yuichi Nakamura wrote:
> I found syscall audit does not work on SH(SuperH).
> I made patch to support syscall audit for SH.

I think this is close, but it looks like you missed the syscall classification 
piece. You can find an example here:

arch/x86_64/kernel/audit.c

Its used for determining which syscalls we are interested in for watches. 

Also, IBM and HP both have released audit test suites. You should run the CAPP 
tests at a minimum to see if you have hooked everything that is expected. If 
you have SE Linux enabled for that platform, you may want to try the LSPP 
tests but you would need have the MLS policy installed.

IBM's announcement is here:

https://www.redhat.com/archives/redhat-lspp/2007-August/msg00002.html

and HP's here:

https://www.redhat.com/archives/linux-audit/2007-August/msg00030.html

And...user space would need an update for the syscall table and arches so that 
you can run the tests. Please send that patch to linux-audit mail list.

Thanks,
-Steve
