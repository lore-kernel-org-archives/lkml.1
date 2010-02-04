Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab0BDTvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:51:05 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49797 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab0BDTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=GIyri+XU9HIyAlSV2I2a0LSbnMX6RPk5/8CfSashoKnofHh3cLSQCoK490iM2ZtQUR
         KGP2uwHW3nv8sgWFSwB6qkXyOQknj60XQIMRZEJNq2+IdWEKJrgbXAt93tapAi+ghW90
         lKIKyYUlW66eO++9+2psmDUnQ8tLJCbfj047c=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
In-Reply-To: <1265308725.4651.14.camel@bigi>
References: <1265060041850@kroah.org> <201002041850.31310.s.L-H@gmx.de>
	 <1265307247.4651.2.camel@bigi>  <201002041931.40493.s.L-H@gmx.de>
	 <1265308725.4651.14.camel@bigi>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 14:50:56 -0500
Message-Id: <1265313056.4651.18.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I was able to reproduce it finally. This fixes it:

---
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index b6e7aae..469193c 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -220,6 +220,7 @@ static const struct trans_ctl_table
trans_net_ipv4_conf_vars_table[] = {
        { NET_IPV4_CONF_PROMOTE_SECONDARIES,    "promote_secondaries" },
        { NET_IPV4_CONF_ARP_ACCEPT,             "arp_accept" },
        { NET_IPV4_CONF_ARP_NOTIFY,             "arp_notify" },
+       { NET_IPV4_CONF_SRC_VMARK,              "src_valid_mark" },
        {}
 };
---

Note we dont have that code anymore in current tree - thats why it
was missed...
If this works, Greg/Dave - please include it in the -stable patch.

cheers,
jamal


On Thu, 2010-02-04 at 13:38 -0500, jamal wrote:
> On Thu, 2010-02-04 at 19:31 +0100, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Thursday 04 February 2010, jamal wrote:
> 
> > > ----
> > >         NET_IPV4_CONF_ARP_ACCEPT=21,
> > >         NET_IPV4_CONF_ARP_NOTIFY=22,
> > >         NET_IPV4_CONF_ACCEPT_LOCAL=23,
> > >         NET_IPV4_CONF_SRC_VMARK=24,
> > >         __NET_IPV4_CONF_MAX
> > > ---
> > > 
> > > I have a feeling you are missing NET_IPV4_CONF_ACCEPT_LOCAL
> > 
> > Yes, you're 100% right - such a hunk is missing from queue-2.6.32 [1]
> > 
> 
> Do you mind changing to NET_IPV4_CONF_SRC_VMARK=23 in that patch?
> As i mentioned in my other email it is a wild guess - so it likely will
> have no effect but worth a try if you have time.
> 
> cheers,
> jamal
> 
> 

