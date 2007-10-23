Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXJWP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXJWP2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXJWP21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:28:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXJWP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:28:26 -0400
Date: Tue, 23 Oct 2007 17:28:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Giacomo Catenazzi <cate@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <20071023152005.GA13767@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0710231725550.16684@fbirervta.pbzchgretzou.qr>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <471D8A4C.3020101@debian.org> <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr>
 <20071023152005.GA13767@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 23 2007 10:20, Serge E. Hallyn wrote:
>
>Once the per-process capability bounding set is accepted
>(http://lkml.org/lkml/2007/10/3/315) you will be able to do something
>like:
>
>	1. Create user 'jdoe' with uid 0

UID 0 is _not_ acceptable for me.

>	2. write a pam module which, when jdoe logs in, takes
>	   CAP_NET_ADMIN out of his capability bounding set
>	3. Now jdoe can log in with the kind of capabilities subset
>	   you describe.

It is not that easy.
CAP_DAC_OVERRIDE is given to the subadmin to bypass the pre-security
checks in kernel code, and then the detailed implementation of
limitation is done inside multiadm.
This is not just raising or lowering capabilities.

>It's not a perfect solution, since it doesn't allow jdoe any way at all
>to directly execute a file with more caps (setuid and file capabilities
>are subject to the capbound).  So there is certainly still a place for
>multiadm.

A normal user can execute suid binaries today, and so can s/he with mtadm.
I do not see where that will change - it does not need any caps atm.
