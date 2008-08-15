Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYHOURY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYHOURY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYHOURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:17:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:55396 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751493AbYHOURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:17:11 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+iidNIqDiizWqVzVpExzqWHsRV+bACNzFNTaBNj4
	WOUTg2Fe24//bv
Date: Fri, 15 Aug 2008 22:17:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Nick Warne <nick@ukfsn.org>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Fixup KERN_INFO in tmscsim.c
In-Reply-To: <20080815121045.48ca37e4@sauron.linicks.net>
Message-ID: <Pine.LNX.4.64.0808152202440.7852@axis700.grange>
References: <20080815121045.48ca37e4@sauron.linicks.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Nick Warne wrote:

> Setting up my new AMD64 I noticed a curious one liner in syslogs:

Wow, are you sure you need the tmscsim driver on your new amd64 system?:-)

> ^Iwith "disable_clustering=1" and report to maintainers

The message priority is indeed missing in the second line, but it has 
nothing to do with the "^I" in your log. I do not know why your syslogd / 
klogd converts a TAB to "^I". But if it is a problem, I think, the correct 
fix would be something like

-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "       with \"disable_clustering=1\" and report to maintainers\n");

Or maybe just remove that printk altogether - it has been there for almost 
2 years now, and I haven't heard a single complaint, but on the other 
hand, maybe you are the first, who at least loaded this driver since 2 
years:-)

Ok, taking into account that this driver is hardly used, I would keep this 
warning in case someone does get a problem.

So, please, redo as above, create with "-p1" format, fix your Sob line

> Signed off by: "Nick Warne" <nick@ukfsn.org>

which has to be

Signed-off-by: Nick Warne <nick@ukfsn.org>

and send the patch inline,

Thanks
Guennadi
---
Guennadi Liakhovetski
