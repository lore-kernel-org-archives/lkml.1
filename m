Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbYJaL4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbYJaL4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYJaL4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:56:21 -0400
Received: from ozlabs.org ([203.10.76.45]:48665 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYJaL4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:56:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18698.62038.907424.657408@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 22:56:06 +1100
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot
	(bisected)
In-Reply-To: <1225452697.8004.211.camel@pasglop>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	<20081030142632.GA15645@csn.ul.ie>
	<18698.7794.500191.189515@cargo.ozlabs.ibm.com>
	<20081031103646.GA24395@csn.ul.ie>
	<18698.59790.393775.139313@cargo.ozlabs.ibm.com>
	<1225452697.8004.211.camel@pasglop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:

> Unless missed something, I think it's narrowed already. When loaded from
> yaboot, there is no relevant difference between zImage and vmlinux here.
> IE. yaboot parses the ELF header of the zImage itself and ignores the
> special notes anyway so only the CAS firmware call is relevant in both
> cases, no ?

Good point.  However, it would be the parse-elf-header firmware call,
rather than the CAS firmware call, since 91a00302 modified the
fake_elf structure (to make it consistent with the CAS structure) but
not the CAS structure.

Paul.
