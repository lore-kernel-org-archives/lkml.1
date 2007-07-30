Return-Path: <linux-kernel-owner+w=401wt.eu-S935624AbXG3NTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624AbXG3NTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbXG3NTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:19:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062AbXG3NS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:18:59 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to EXPORT_SYMBOL_GPL
Date: Mon, 30 Jul 2007 09:18:41 -0400
User-Agent: KMail/1.9.7
Cc: David Woodhouse <dwmw2@infradead.org>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
References: <20070729150233.GX16817@stusta.de>
In-Reply-To: <20070729150233.GX16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707300918.41408.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 11:02:33 Adrian Bunk wrote:
> They are still completely unused, but hopefully some of the theoretical
> code that might use it will appear in the kernel in the near future...
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Acked-by: Steve Grubb <sgrubb@redhat.com>

I am reluctant to say that I ack this patch for a couple reasons:

1) We are talking about a basic logging facility that should be open like 
printk() is.

2) There are no user space GPL restrictions to use the audit netlink API, so 
why restrict who can send audit events via the in-kernel interfaces? It just 
doesn't make sense to have 2 different licenses for in-kernel vs user space 
audit event recording. Its the same subsystem differing only by where the 
event originated.

3) The API has been unrestricted for years. I don't think its a good idea to 
take a basic logging API away from people that have programmed to it.

4) In the absence of the in-kernel audit logging api, people will either 
create parallel infrastructure or resort to using printk. It will be 
difficult for end users to correlate security events from 2 different logs.

I would support there being a mechanism for anyone who wants to reduce the 
number of exported symbols for their own kernels - I believe that is the 
basic problem here. But I think there are enough reasons to continue keeping 
this API open and unrestricted for anyone that wants it that way.

-Steve
