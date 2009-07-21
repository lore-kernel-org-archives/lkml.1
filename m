Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZGUPiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZGUPiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZGUPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:38:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40546 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469AbZGUPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:38:15 -0400
Date: Tue, 21 Jul 2009 16:38:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all mmap_zero
 operations
Message-ID: <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
In-Reply-To: <1248189524.2654.301.camel@localhost>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
	<20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
	<1248189524.2654.301.camel@localhost>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> turns it off for the whole system when you install WINE.  This patch
> doesn't change that fact.  All it does is add that requirement to
> SELinux systems that already exists on non-selinux systems.

Prior to this an SELinux system could implement sensible security. The
fact Fedora didn't was paranoia and fear over a bad experience made what
five years ago ?

> > Am I missing something here, this "solution" sounds completely brain
> > dead ?
> 
> Well, with patch 2/2 you still get your SELinux protections (only for 1
> page) even if you disable it for the whole system.  So in the end, you
> have better protection than you have today with this series....

We know one page isn't sufficient. That has been seen from some exploit
cases.

So this looks to me like a regression in features, that makes the system
less secure and doesn't solve anything at all.

Whereas if you just set the default SELinux user confinement to allow
everything but mapping low pages you wouldn't actually need to mess up
the kernel ?

Currently I have low page protection and I don't have to run wine as
CAP_SYS_RAWIO (which comes in the "sucidial ideas") category. I consider
the loss of that ability a regression.

Alan
