Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab0BEOwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:52:05 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46379 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab0BEOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=lpHUVbRkdcuZJm11HZLrEV6lUVkbw0ViC7Vv8T9dHiVjDbj5eXuivb9rSNezjN81ed
         y2GyZQQC3KI9rg8d1c6ucvHc9UW1Gu9pd0jFqD6pyg8HZ/PEItI0NFHO+c+xwiQyvooF
         mqLJ5dv9D2o75Q2VKEB+N8BNGEl8NPr8nM+gg=
Subject: Re: [46/74] net: restore ip source validation
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Randolf Pohl <randolf.pohl@gmx.de>
Cc: Sven Joachim <svenjoac@gmx.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100205143441.280460@gmx.net>
References: <20100205143441.280460@gmx.net>
Content-Type: text/plain
Date: Fri, 05 Feb 2010 09:51:54 -0500
Message-Id: <1265381514.5661.1.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 15:34 +0100, Randolf Pohl wrote:
> [...]
> 
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -490,6 +490,7 @@ enum
> >  	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
> >  	NET_IPV4_CONF_ARP_ACCEPT=21,
> >  	NET_IPV4_CONF_ARP_NOTIFY=22,
> > +	NET_IPV4_CONF_SRC_VMARK=24,
> >  	__NET_IPV4_CONF_MAX
> >  };
> > 
> 
> Must these be contiguous, i.e. 23?

The problem is elsewhere. Here's the fix.

--
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

cheers,
jamal


