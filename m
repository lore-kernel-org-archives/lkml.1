Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYIEQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYIEQo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYIEQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:44:20 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16281 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYIEQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:44:19 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: + security-selinux-include-netlabelh-fix-two-build-errors.patch added to -mm tree
Date: Fri, 5 Sep 2008 12:44:15 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev <netdev@vger.kernel.org>
References: <200809050326.m853QB13012853@imap1.linux-foundation.org> <20080904210033.20700500.randy.dunlap@oracle.com>
In-Reply-To: <20080904210033.20700500.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051244.15420.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 12:00:33 am Randy Dunlap wrote:
> Even with this patch, net/netlabel/netlabel_mgmt.c has build errors
> when CONFIG_IPV6=n:

Interesting, I tried to reproduce this quickly by changing my .config, 
running 'make oldconfig', verifying that CONFIG_IPV6 was still "n" (it 
was actually commented out), and then running 'make M=net/netlabel' ... 
the result was no error.

You are correct, I obviously made a mistake in the code (which I am 
fixing now) but I don't understand why the steps I took above didn't 
highlight the problem?  What am I missing?

> linux-next-20080904/net/netlabel/netlabel_domainhash.c:79: warning:
> unused variable 'tmp6'
> linux-next-20080904/net/netlabel/netlabel_domainhash.c:78: warning:
> unused variable 'iter6'
> linux-next-20080904/net/netlabel/netlabel_domainhash.c:340: warning:
> unused variable 'tmp6'
> linux-next-20080904/net/netlabel/netlabel_domainhash.c:301: warning:
> unused variable 'iter6'
> linux-next-20080904/net/netlabel/netlabel_mgmt.c:219: error: implicit
> declaration of function 'netlbl_af6list_add'
> linux-next-20080904/net/netlabel/netlabel_mgmt.c:317: error: implicit
> declaration of function 'netlbl_af6list_foreach_rcu'
> linux-next-20080904/net/netlabel/netlabel_mgmt.c:318: error: expected
> ';' before '{' token make[3]: *** [net/netlabel/netlabel_mgmt.o]
> Error 1

-- 
paul moore
linux @ hp
