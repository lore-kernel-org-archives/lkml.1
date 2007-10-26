Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXJZJF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXJZJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXJZJFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:05:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:41132 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927AbXJZJFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:05:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NfAUVUfbNmBC1jTIdsE1jOPe0d2bVhttcxh/FXh
	mjl1/HA1ngktw8
Subject: Re: kernel 2.6.23 CFS problem?
From: Mike Galbraith <efault@gmx.de>
To: "Wang, Baojun" <wangbj@lzu.edu.cn>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710261532.22265.wangbj@lzu.edu.cn>
References: <200710261057.48179.wangbj@lzu.edu.cn>
	 <20071026044502.GB2458@hacking> <393381760.18886@lzu.edu.cn>
	 <200710261532.22265.wangbj@lzu.edu.cn>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 11:05:42 +0200
Message-Id: <1193389542.7701.18.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 15:32 +0800, Wang, Baojun wrote:

> > Perhaps he has any tasks stuck in 'D' state?  If so, SysRq-t output for
> > these would be a good thing to collect.  What leads him to suspect the
> > process scheduler, etc.  More details are needed.

> The task is S+ state, please see in the attachment tarball, SysRq-t output has 
> also been attached, I wish it would help. I doubt it's the CFS problem 
> because it's first introduced into the 2.6.23 kernel.

(yeah, but there were a truckload of other changes as well)

Looking at your data, _my_ first suspect would be the 2.6.22->2.6.23
futex changes.  I'd revert all of the changes to kernel/futex.c and
kernel/futex_compat.c, and see if the problem went away.  If it didn't,
I'd then do a full git bisect to nail it down.

	-Mike

