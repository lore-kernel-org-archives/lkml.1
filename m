Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZKSLrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZKSLrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZKSLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:47:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZKSLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:46:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other macvlan devices
Date: Thu, 19 Nov 2009 12:44:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <200911182332.56309.arnd@arndb.de> <m1bpiz8k1x.fsf@fess.ebiederm.org>
In-Reply-To: <m1bpiz8k1x.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191244.43916.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+J+6Jx6m2AuhitG0/+NEKv/zrc+uo6YBppoiT
 ouWlogdLIpC7sJUAsHXmkax8xcwgMBz9+kkt6I+eaLWuUM6HVf
 JderrpkELQ34WrELzopkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009, Eric W. Biederman wrote:
> > It seems that we should never drop dst then. We either forward the frame to
> > netif_rx or to dev_queue_xmit, and from how I read it now, we want to keep
> > the dst in both cases.
> 
> When we loop back on our selves we certainly need to have dst clear because
> we don't know how to cache routes through multiple network namespaces.

Ah, right. So should I add the explicit dst_drop to the new dev_forward_skb()
then? The veth driver doesn't need it, but it also looks like it won't hurt.

	Arnd <><
