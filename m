Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYFUT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYFUT6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYFUT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:57:58 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:27965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYFUT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cHcvuXaNnSekiRVoGZW4fj403xkdpculYCRuqsxtH5xx1YLhO8ymxokJC/brN51m7O
         HA27x5ZMJ283KHs1ZEMKUtXYGKYBsZ7+niIQrgVxXYwPq8XI2iq9X821cZLLGQD/BcHv
         EUfryDGAfGQOIwfZ8oB315/K7dS33YsrnLw20=
Date: Sat, 21 Jun 2008 20:55:26 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: wcong@critical-links.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru
Subject: Re: [Patch] net/sched/sch_generic.c: fix an error pointer
Message-ID: <20080621195526.GA25715@hack.netcabo.pt>
References: <20080619153714.5614d5be@hack> <20080619.161108.23678497.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619.161108.23678497.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:11:08PM -0700, David Miller wrote:
>From: WANG Cong <wcong@critical-links.com>
>Date: Thu, 19 Jun 2008 15:37:14 +0100
>
>> ERR_PTR() ususally encodes an negative errno, not positive.
>> 
>> Note, in the following patch, 'err' is initialized as:
>> 
>> int err = -ENOBUFS;
>> 
>> Signed-off-by: WANG Cong <wcong@critical-links.com>
>
>Patch is whitespace corruped and line wrapped by your
>email client.
>
>Please fix this and resubmit, thank you.

I am very sorry for this. Resend it with mutt. :-)

--------------->

ERR_PTR() ususally encodes an negative errno, not positive.

Note, in the following patch, 'err' is initialized as:

int err = -ENOBUFS;

Signed-off-by: WANG Cong <wcong@critical-links.com>
Cc: David Miller <davem@davemloft.net>
Cc:  Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

---
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d355e5e..13afa72 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -468,7 +468,7 @@ struct Qdisc *qdisc_alloc(struct net_device *dev, struct Qdisc_ops *ops)
 
 	return sch;
 errout:
-	return ERR_PTR(-err);
+	return ERR_PTR(err);
 }
 
 struct Qdisc * qdisc_create_dflt(struct net_device *dev, struct Qdisc_ops *ops,
