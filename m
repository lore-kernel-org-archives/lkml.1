Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYEEEZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYEEEZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYEEEYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:24:47 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:38614 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYEEEYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:24:46 -0400
Date: Mon, 05 May 2008 13:24:52 +0900 (JST)
Message-Id: <20080505.132452.98853465.yoshfuji@linux-ipv6.org>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, davidel@xmailserver.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200805050342.m453gktl029817@devserv.devel.redhat.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
Organization: USAGI Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <200805050342.m453gktl029817@devserv.devel.redhat.com> (at Sun, 4 May 2008 23:42:46 -0400), Ulrich Drepper <drepper@redhat.com> says:

> This patch adds support for flag values which are ORed to the type passwd
> to socket and socketpair.  The additional code is minimal.  Beside
> decoding the flags with the library function introduced in a prior patch
> all that has to be done is to pass the new value around.
> 
> The internal functions sock_alloc_fd and sock_map_fd get a new parameters
> and all callers are changed.

Well, this seems the only patch that overrides basic context of the
arguments.  (Or, we have already "flags" argument for other APIs
that do not require new API.)

To me, it seems overriding 2nd argument is a too ad-hoc workaround,
and introducing new syscalls with flags is cleaner, e.g.,
    psocket(family, socktype, protocol, flags);
    psocketpair(d, type, protocol, int sv[2], flags);

--yoshfuji
