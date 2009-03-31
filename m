Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZCaWK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZCaWK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbZCaWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:10:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757669AbZCaWKk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:10:40 -0400
Date: Tue, 31 Mar 2009 15:10:28 -0700 (PDT)
Message-Id: <20090331.151028.42671906.davem@davemloft.net>
To: oliver@neukum.org
Cc: Larry.Finger@lwfinger.net, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904010013.05494.oliver@neukum.org>
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
	<200904010013.05494.oliver@neukum.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>
Date: Wed, 1 Apr 2009 00:13:04 +0200

> Am Dienstag 31 März 2009 20:45:49 schrieb Larry Finger:
> 
> > @@ -796,7 +799,7 @@ static int kaweth_start_xmit(struct sk_b
> 
> > @@ -848,7 +851,7 @@ skip:
> >  		net->trans_start = jiffies;
> >  	}
> >
> > -	spin_unlock(&kaweth->device_lock);
> > +	spin_unlock_irq(&kaweth->device_lock);
> 
> Here you enable interrupts. Are you sure ndo_start_xmit is never
> called with interrupts disabled?

It must never be invoked that way, this would break so many
drivers.

On the other hand, all of these driver paths never execute
in a real hardware interrupt context, the deepest it gets
into is software interrupts.  So spin_*lock*_bh() might be
more appropriate.
