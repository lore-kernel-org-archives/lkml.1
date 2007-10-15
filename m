Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbXJOXjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbXJOXjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXJOXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:39:13 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46392 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755764AbXJOXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:39:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=O47OiWuKVOnd/KxVe2LFQHk4I1WR8HVT+8502TTB7uj1GbQwB2eUen+1BVn6jv+ktr6h1qVIJb8x0yx5+Lf9hPENjv0lUwgkHMzyK/aTOVntnD6eCGlVEk9CHNrBcrxkKloYoRS/jkl2UaRBrz1N6AfEJfNx9aI9dhIjpk+ITfY=  ;
X-YMail-OSG: cu8wNvMVM1lbqgtJFZytfrRsouaxd6VaN4EffpR9jV_HfeqF_Hgdl4mN8E6xvPiuavlGcnqQlQ--
Date: Mon, 15 Oct 2007 16:39:10 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Cc: stern@rowland.harvard.edu, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
References: <200710091443.54998.david-b@pacbell.net>
 <20071009.150040.55724885.davem@davemloft.net>
 <20071009.213507.78708496.davem@davemloft.net>
 <20071015.150124.78710191.davem@davemloft.net>
In-Reply-To: <20071015.150124.78710191.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071015233910.5A17123BC99@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Bad news, even with the rwsem after a lot more testing I can still
> trigger the hang in ohci_hub_control() :-(
>
> I think we need to go back to considering the total serialization
> approach to this problem.

We shouldn't need that.  What happens if you add an msleep(5)
before ehci-hcd::ehci_run() drops ehci_cf_port_reset_rwsem?

The theory there being that the switch triggered by setting CF
doesn't take effect instantaneously, contrary to the effective
assumption of that code.  A delay of 5 msec seems like it should
be more than enough, but that's kind of a guess ... it's good to
keep that low, since unfortunately that's in the critical path
for OLPC "resume from idle".

- Dave

