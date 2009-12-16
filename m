Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZLPP3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZLPP3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZLPP3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:29:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:49224 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758716AbZLPP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:29:13 -0500
From: Michael Stone <michael@laptop.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>, "David Lang" <david@lang.hm>,
       "Oliver Hartkopp" <socketcan@hartkopp.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Valdis Kletnieks" <Valdis.Kletnieks@vt.edu>,
       "Bryan Donlan" <bdonlan@gmail.com>,
       "Evgeniy Polyakov" <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "James Morris" <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Bernie Innocenti" <bernie@codewiz.org>,
       "Mark Seaborn" <mrs@mythic-beasts.com>
Subject: Re: setrlimit(RLIMIT_NETWORK) vs. prctl(???)
Date: Wed, 16 Dec 2009 10:30:49 -0500
Message-Id: <1260977452-2334-1-git-send-email-michael@laptop.org>
X-Mailer: git-send-email 1.6.6.rc1
In-Reply-To: <20091215053307.GA6837@heat>
References: <20091215053307.GA6837@heat>
In-reply-to: <20091215053307.GA6837@heat>
To: Ulrich Drepper <drepper@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

As promised, here's a draft based on prctl() for comparison with the
rlimit()-based approach presented in the first attempt.

It behaves as I expect in simple testing with busybox "nc" and I'll do a more
thorough test shortly. I'm sending it now because I think that it's good enough
to give a decent overview of what the end result of this implementation
strategy might look like.

Regards,

Michael

------

Michael Stone (3):
  Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
  Security: Implement prctl(PR_SET_NETWORK, PR_NETWORK_OFF) semantics.
  Security: Document prctl(PR_{GET,SET}_NETWORK).

 Documentation/prctl_network.txt |   69 +++++++++++++++++++++++++++++++++++++++
 include/linux/prctl.h           |    7 ++++
 include/linux/prctl_network.h   |    7 ++++
 include/linux/sched.h           |    2 +
 kernel/Makefile                 |    2 +-
 kernel/fork.c                   |    2 +
 kernel/prctl_network.c          |   37 +++++++++++++++++++++
 kernel/ptrace.c                 |    2 +
 kernel/sys.c                    |    7 ++++
 net/socket.c                    |   51 +++++++++++++++++++++-------
 net/unix/af_unix.c              |   19 +++++++++++
 11 files changed, 191 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/prctl_network.txt
 create mode 100644 include/linux/prctl_network.h
 create mode 100644 kernel/prctl_network.c

