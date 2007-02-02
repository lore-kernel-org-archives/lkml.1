Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbXBBFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbXBBFTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbXBBFTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:19:38 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33819 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255AbXBBFTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:19:37 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: epoll handling in the alpha port
Date: Fri, 2 Feb 2007 00:19:35 -0500
User-Agent: KMail/1.9.6
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org, alpha@gentoo.org
References: <200702011520.46723.vapier@gentoo.org> <20070201210555.ac637298.akpm@linux-foundation.org>
In-Reply-To: <20070201210555.ac637298.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020019.36248.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 February 2007, Andrew Morton wrote:
> It might be to late to fix this - we risk breaking userspace which worked
> around it.

we'd be breaking userspace API, but not ABI ... and the largest consumers out 
there (glibc/uclibc) have not been accounting for this, so we wouldnt be 
breaking them

that's how we noticed the issue in Gentoo ... all the epoll calls are 
automatically declared -ENOSYS stubs in glibc's libc.so

is there some other large consumer i'm not thinking of ?

> It would be safer to add the correct definitions while leaving the old ones
> in place.

in the end, either works for me ... i can see linux's pretty hard 'dont break 
userspace' policy coming into play here
-mike
