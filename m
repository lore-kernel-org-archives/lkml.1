Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbZLXBk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbZLXBk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZLXBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:40:57 -0500
Received: from lists.laptop.org ([18.85.2.145]:32877 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbZLXBk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:40:56 -0500
Date: Wed, 23 Dec 2009 20:42:58 -0500
From: Michael Stone <michael@laptop.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 0/3] Discarding networking privilege via LSM
Message-ID: <20091224014258.GA24115@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218163348.GA24269@heat>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

As you requested, here's a (rough) draft of my patch series which uses the
security_* hooks instead of direct modification of the networking functions. 

Have you further suggestions for improvement?

Regards,

Michael

P.S. - The most notable behavioral difference between this patch and the
previous one is that abstract unix sockets are exempted from control in this
patch but are restricted by the previous one. We can revisit this detail in
subsequent patches if this approach seems viable.

Michael Stone (3):
   Security: Add prctl(PR_{GET,SET}_NETWORK) interface. (v3)
   Security: Implement prctl(PR_SET_NETWORK, PR_NETWORK_OFF) semantics. (v3)
   Security: Document prctl(PR_{GET,SET}_NETWORK). (v3)

  Documentation/prctl/network.txt |   74 ++++++++++++++++++++++++++
  include/linux/prctl.h           |    7 +++
  include/linux/prctl_network.h   |    7 +++
  include/linux/sched.h           |    2 +
  kernel/sys.c                    |   32 +++++++++++
  security/Kconfig                |   13 +++++
  security/Makefile               |    1 +
  security/prctl_network.c        |  110 +++++++++++++++++++++++++++++++++++++++
  8 files changed, 246 insertions(+), 0 deletions(-)
  create mode 100644 Documentation/prctl/network.txt
  create mode 100644 include/linux/prctl_network.h
  create mode 100644 security/prctl_network.c
