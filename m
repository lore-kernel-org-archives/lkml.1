Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXKGPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXKGPZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXKGPYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:24:52 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:47894 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885AbXKGPYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:24:51 -0500
Date: Thu, 8 Nov 2007 00:24:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Yuichi Nakamura <ynakam@hitachisoft.jp>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, Al Viro <aviro@redhat.com>
Subject: Re: [patch] audit support for SH
Message-ID: <20071107152439.GA28272@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Yuichi Nakamura <ynakam@hitachisoft.jp>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
	Al Viro <aviro@redhat.com>
References: <20071107135743.C1BD.YNAKAM@hitachisoft.jp> <200711071015.33765.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711071015.33765.sgrubb@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 10:15:33AM -0500, Steve Grubb wrote:
> On Wednesday 07 November 2007 12:04:46 am Yuichi Nakamura wrote:
> > I found syscall audit does not work on SH(SuperH).
> > I made patch to support syscall audit for SH.
> 
> I think this is close, but it looks like you missed the syscall classification 
> piece. You can find an example here:
> 
> arch/x86_64/kernel/audit.c
> 
> Its used for determining which syscalls we are interested in for watches. 
> 
Looking at this, it seems like the classification stuff for 32-bit is
generic, it's just the compat bits that are special cased and wrap back
in through the 32-bit classifier.

Is there any point in keeping the 32-bit audit.c rather than simply
moving it to kernel/ or lib/ and leaving the arch/ bits as compat
wrappers only?

At least powerpc, x86, and ia64 look like they could go that way.
