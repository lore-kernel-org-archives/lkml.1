Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128Ab0AWI1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0AWI1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0AWI1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:27:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60754
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758Ab0AWI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:27:52 -0500
Date: Sat, 23 Jan 2010 00:28:03 -0800 (PST)
Message-Id: <20100123.002803.135008520.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
       mingo@redhat.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org
Subject: Re: [PATCH v2] ftrace: unify arch_syscall_addr() implementations
From: David Miller <davem@davemloft.net>
In-Reply-To: <1264230643-29434-1-git-send-email-vapier@gentoo.org>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
	<1264230643-29434-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 23 Jan 2010 02:10:43 -0500

> Most implementations of arch_syscall_addr() are the same, so create a
> default weak version in common code.  New arch ports don't have to waste
> time copying & pasting this simple function.  The Blackfin version is
> going to be exactly the same for example.
> 
> The s390/sparc versions need to be different, so document why.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

You can just have the extern declaration match whatever the
arch needs (long or int) in the generic ftrace.c code and
then unconditionally do the (unsigned long) case.

That way even s390/sparc can use the generic implementation.
