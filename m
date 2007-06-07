Return-Path: <linux-kernel-owner+w=401wt.eu-S937144AbXFGVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937144AbXFGVeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758791AbXFGVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:34:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbXFGVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:34:11 -0400
Message-ID: <46686810.6030805@redhat.com>
Date: Thu, 07 Jun 2007 13:18:24 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com> <466864F8.2050903@cosmosbay.com>
In-Reply-To: <466864F8.2050903@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> I am afraid randomization wont really work if /sbin/init or /bin/bash
> for example uses one (or more) unseq fd :
> The 'random base' will be propagated at fork()/exec() time ?

The base certainly should be reset o fork.  Yes, this might expand the
region in which descriptors are allocated due to inherited descriptors.
 But I consider this the application's problem and it usually is not
really an issue.  Apps have to explicitly request using the new
descriptors and they can use CLOEXEC (CLOFORK) correctly.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaGgQ2ijCOnn/RHQRAutyAKChp9KT9NVfUTD76GRhyY62GUTtaACglgxi
N/4+vmcUPEYtLmUTYKVjMvg=
=otvw
-----END PGP SIGNATURE-----
