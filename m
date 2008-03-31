Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYCaUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYCaUVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYCaUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:21:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYCaUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:21:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] do_wait: return security_task_wait() error code in place of -ECHILD
In-Reply-To: Oleg Nesterov's message of  Monday, 31 March 2008 15:03:12 +0400 <20080331110312.GC400@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org>
	<20080331035701.3926726F8E9@magilla.localdomain>
	<20080331035949.608A226F8E9@magilla.localdomain>
	<20080331110312.GC400@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080331202052.C333126F8E9@magilla.localdomain>
Date: Mon, 31 Mar 2008 13:20:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Suppose that we have 2 childs. The first one is running, the second is zombie
> but nacked by security_task_wait(). Now waitpid(-1, WHOHANG|WEXITED) returns 0,
> a bit strange/confusing.

What else would it do?  There is a child that will be reapable eventually
(the running one).  It might be even more strange and more confusing if you
hid the running child just because there is a permission-denied one.  If
you ask specifically for the permission-denied zombie you'll get the
permission error.  I'm not sure we can do better.


Thanks,
Roland


