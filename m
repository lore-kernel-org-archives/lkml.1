Return-Path: <linux-kernel-owner+w=401wt.eu-S935827AbYBTQkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935827AbYBTQkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbYBTQat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:30:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37686 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934710AbYBTQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:30:45 -0500
Date: Wed, 20 Feb 2008 16:19:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: tty && pid problems
Message-ID: <20080220161941.6e9a2e16@core>
In-Reply-To: <20080220161823.GB146@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru>
	<20080215193756.9e5b8205.akpm@linux-foundation.org>
	<20080216140212.GA1421@tv-sign.ru>
	<20080217231019.GA83@tv-sign.ru>
	<m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
	<23492.1203464394@turing-police.cc.vt.edu>
	<20080220161823.GB146@tv-sign.ru>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > *ping* - Any further activity on this one?  I got bit by it as well on
> > the very first attempted boot of 25-rc2-mm1, the instant it tried to leave
> > single-user and go multi-user.
> 
> Valdis, any chance you can try the
> 	"[PATCH] (for -mm only) put_pid: make sure we don't free the live pid"
> I sent? just to make sure we don't have other problems here.

There is some other iffy locking of the pid objects ever since they were
changed from pid_t to ref counted structs. Whoever did that didn't add
any locking for it, and the old code knew it was "safe" not to.

I've added locks in my test tree and now I've finally got -mm to build
will do some testing then push more stuff upstream
