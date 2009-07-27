Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZG0SOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZG0SOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZG0SOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:14:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44083 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZG0SOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:14:30 -0400
Date: Mon, 27 Jul 2009 20:14:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Hannes Eder <heder@google.com>
cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/5] IPVS: prefix EnterFunction and LeaveFunction
 msg with "IPVS:"
In-Reply-To: <20090727134616.12897.7639.stgit@jazzy.zrh.corp.google.com>
Message-ID: <alpine.LSU.2.00.0907272013070.20984@fbirervta.pbzchgretzou.qr>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com> <20090727134616.12897.7639.stgit@jazzy.zrh.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-07-27 15:46, Hannes Eder wrote:
>
>Now all printk messages from IPVS are prefixed with "IPVS:".
>
>+#define EnterFunction(level)						       \
>+	do {								       \
>+		if (level <= ip_vs_get_debug_level())			       \
>+			printk(KERN_DEBUG "IPVS: Enter: %s, %s line %i\n",     \
>+				__func__, __FILE__, __LINE__);		       \
>+	} while (0)
>+#define LeaveFunction(level)						       \
>+	do {								       \
>+		if (level <= ip_vs_get_debug_level())			       \
>+			printk(KERN_DEBUG "IPVS: Leave: %s, %s line %i\n",     \
>+				__func__, __FILE__, __LINE__);		       \
>+	} while (0)

I think you should rather make use of pr_fmt:

<before any #includes>
#define pr_fmt(x) "IPVS: " x

And then use pr_<level>("Elvis has left the building") in code. This
will add IPVS: automatically to all pr_* calls, alleviating the need
to manually type it into all printks.
Of course, if you only want it for the two defines here, scrap
my idea :)
