Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbXFFW7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbXFFW7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965495AbXFFW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:58:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965683AbXFFW6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:58:36 -0400
Message-ID: <46673BE5.8040605@redhat.com>
Date: Wed, 06 Jun 2007 15:57:41 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: davidel@xmailserver.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
       dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606.154434.21926922.davem@davemloft.net>
In-Reply-To: <20070606.154434.21926922.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Miller wrote:
> Since the valid range of "domain" values is quite small,
> we could avoid the new system call by cribbing some of the
> upper bits of the 'domain' argument.
> 
> Valid existing programs pass in valid 'domain' values and
> thus will not set any of the new flags.

I can see several problems with that:

- - experimental implementers might choose domain values which definitely
won't collide with others

- - the flags parameter ideally allows using the same values used for
open's mode argument.  The lowest value I can see making sense is
O_NONBLOCK (04000).

- - how to recognize kernels without the support?  -EAFNOSUPPORT can also
with new kernels mean it's actually the domain which is wrong

- - there might be new flags we want to use over time

I would strongly argue that any change we're doing in this area at
userlevel would involve a new interface.  Programs also need new
definitions from headers files.  This means a recent enough glibc will
be needed in any case.  Unless programs use their own definitions in
which case they might as well use the syscall() function.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGZzvl2ijCOnn/RHQRAgV0AKDBDhqSQ/cs4qGYLKGL4dwzpFZ2zgCgl/qO
oFKnQ2eRuiziRu/N5vwWCeM=
=tttP
-----END PGP SIGNATURE-----
