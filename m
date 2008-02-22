Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbYBVJsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbYBVJsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBVJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:48:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33085 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbYBVJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:48:44 -0500
Date: Fri, 22 Feb 2008 09:37:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: tty && pid problems
Message-ID: <20080222093752.09dbfc53@core>
In-Reply-To: <m1ejb56a7q.fsf@ebiederm.dsl.xmission.com>
References: <20080215180204.GA4359@tv-sign.ru>
	<20080215193756.9e5b8205.akpm@linux-foundation.org>
	<20080216140212.GA1421@tv-sign.ru>
	<20080217231019.GA83@tv-sign.ru>
	<m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
	<23492.1203464394@turing-police.cc.vt.edu>
	<20080220161823.GB146@tv-sign.ru>
	<20080220161941.6e9a2e16@core>
	<m1ejb56a7q.fsf@ebiederm.dsl.xmission.com>
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

> > I've added locks in my test tree and now I've finally got -mm to build
> > will do some testing then push more stuff upstream
> 
> Thanks.  At the tty layer that was probably me.
> Most of the instances already appear to be nested in some other kind of
> locking, but that doesn't make no additional locking correct or ensure
> that it will give a uniform result.

Fortunately your pid struct is ref counted so not too hard to sort out.
Need to look at procfs but at worst tty needs to export a function which
returns a reference bumped pid struct to people who stick their nose in
from outside.

Alan
