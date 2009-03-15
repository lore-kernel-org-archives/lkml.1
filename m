Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbZCOTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbZCOTjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbZCOTdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:33:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51205 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759531AbZCOTde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:33:34 -0400
From: Ben Hutchings <bhutchings@solarflare.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <49BD2FDF.5050504@gmail.com>
References: <49BA8710.20808@gmail.com> <49BAE95D.7060001@gmail.com>
	 <49BD2FDF.5050504@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Solarflare Communications
Date: Sun, 15 Mar 2009 19:33:28 +0000
Message-Id: <1237145608.4209.49.camel@hashbaz.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.2.253
X-SA-Exim-Mail-From: bhutchings@solarflare.com
Subject: Re: build bug on kfree(struct sk_buff*)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-15 at 17:42 +0100, Roel Kluin wrote:
> I noticed that my initial attempt was invalid. The one below appears to be
> correct, although I am not sure whether there is a better implementation.
> 
> this patch also fixes a kfree(skb) in net/core/dev.c, what do you think?
[...]

There are many types that should not be allocated and freed using the
general-purpose heap functions.  Why provide this check only for struct
skbuff?

Perhaps you should try to find a general way of detecting this, such as
a type annotation for sparse.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
