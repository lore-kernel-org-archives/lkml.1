Return-Path: <linux-kernel-owner+w=401wt.eu-S937200AbXFGVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937200AbXFGVof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935911AbXFGVoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:44:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4804 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935335AbXFGVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:44:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 14:44:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <46686810.6030805@redhat.com>
Message-ID: <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
 <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
> > I am afraid randomization wont really work if /sbin/init or /bin/bash
> > for example uses one (or more) unseq fd :
> > The 'random base' will be propagated at fork()/exec() time ?
> 
> The base certainly should be reset o fork.  Yes, this might expand the
> region in which descriptors are allocated due to inherited descriptors.
>  But I consider this the application's problem and it usually is not
> really an issue.  Apps have to explicitly request using the new
> descriptors and they can use CLOEXEC (CLOFORK) correctly.

This is kinda fishy. We'll end up with very large map with lots of 
unused space in them.
What we can sanily do, is re-random the base if no fds are in there (of 
course CLOFORK and CLOEXEC do not count).



- Davide


