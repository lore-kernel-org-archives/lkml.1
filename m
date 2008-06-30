Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYF3O2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYF3O2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYF3O23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:28:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35689 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYF3O22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:28:28 -0400
X-Sasl-enc: 9JVxR04Gi3isp4MCSB6iFYx9rPtCQz+ltBvk+SHfmF1B 1214836106
Date: Mon, 30 Jun 2008 11:28:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, ext Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
Message-ID: <20080630142822.GA22984@khazad-dum.debian.net>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <200806281251.21299.david-b@pacbell.net> <4867A2DE.3070509@nokia.com> <200806292009.26975.david-b@pacbell.net> <48686D8F.8010901@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48686D8F.8010901@nokia.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Stefan Becker wrote:
> Good question. What happens when you mix a random and a not-so-random  
> source: does the result have an as good random quality as the original  

It becomes unusable.  In fact, I find it likely that shared IRQs are not
safe for random data gathering at all in general. IRQs are not in fact
completely random, they just (sometimes) have a very small ammount of
randomness in them.  And the combined result you see in a shared IRQ line
could be correlated or "get somewhat more correlated" because of the sharing
(they go over the same BUS -> one can delay the other, etc)... and that
correlation might be dangerous.

IMO, the safe thing to do is to block shared IRQs from being used as random
sources.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
