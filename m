Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYIQPgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYIQPgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYIQPgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:36:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYIQPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:36:43 -0400
X-Sasl-enc: Kkpck2E1xooBB7+SnaQvDnzRhqqj73QdIsDRsPc4NLG7 1221665802
Date: Wed, 17 Sep 2008 12:36:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917153637.GD5186@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <200809171622.55882.mb@bu3sch.de> <20080917145007.GA5186@khazad-dum.debian.net> <48D1221B.1000601@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D1221B.1000601@lwfinger.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > He means rfkill_force_state() should change the LED state in the process,
> > which it isn't doing.
> > 
> > It is an one-line patch, I am testing it now.
> 
> If your one-line patch fixes my regression, then I'll ACK it for 2.6.27.

Sorry, it can't fix that regression by itself, since b43 is not using
rfkill_force_state() in mainline.

It will fix the same issue you are experiencing on b43 in anything that uses
rfkill_force_state(), which means (for mainline): iwlwifi, rt2x00,
thinkpad-acpi and hp-wmi.

It is a regression only on b43 and thinkpad-acpi, as the other drivers above
didn't use rfkill_force_state() in 2.6.26.

To fix the regression in b43, you'd be faced with the need of both my simple
patch AND Matthew's more complex one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
