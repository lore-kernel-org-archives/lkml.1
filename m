Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZLRD5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZLRD5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZLRD5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:57:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53119 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZLRD5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:57:31 -0500
To: Michael Stone <michael@laptop.org>
Cc: Mark Seaborn <mrs@mythic-beasts.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
References: <20091218030056.GC3047@heat> <20091218033128.GB23514@heat>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Dec 2009 19:57:09 -0800
In-Reply-To: <20091218033128.GB23514@heat> (Michael Stone's message of "Thu\, 17 Dec 2009 22\:31\:28 -0500")
Message-ID: <m16385vsru.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/3] Security: Implement prctl(PR_SET_NETWORK, PR_NETWORK_OFF) semantics. (v2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

> Return -EPERM any time we try to __sock_create(), sys_connect(), sys_bind(),
> sys_sendmsg(), or __ptrace_may_access() from a process with PR_NETWORK_OFF set
> in current->network unless we're working on a socket which is already connected
> or on a non-abstract AF_UNIX socket.

It appears to me that the current security hooks are sufficient for what
you are doing.

The one true security module business prevents you from actually using the
security hooks, but could you create wrappers for the network security
hooks so the logic of the network stack does not need to change.

At the very least the huge separation of the test for AF_UNIX and
the test to see if it is a an anonymous AF_UNIX socket is pretty
large.  Structuring the code in such a way as to keep that together would
be nice.

Eric
