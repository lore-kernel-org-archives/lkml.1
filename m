Return-Path: <linux-kernel-owner+w=401wt.eu-S1765726AbYBVOOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765726AbYBVOOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYBVOOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:14:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:50316 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYBVOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:14:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alexey Zaytsev <zaytsev.a@protei.ru>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Fri, 22 Feb 2008 15:13:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru>
In-Reply-To: <47BEAF3B.3080809@protei.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221513.58608.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 12:17:15 Alexey Zaytsev wrote:
> 
> Hello.
> 
> The bcm43xx driver won't work any more, if the b44 Ethernet
> driver is enabled. This happens because the b44 driver
> needlessly enables the b43_pci_bridge code, which claims
> the same pci ids as the bcm43xx driver. The b43_pci_bridge
> code is needed for the b43{legacy} drivers, but for the
> b44, only the "ssb pci core" is needed.
> 
> This patch separates the ssb b43 pci bridge and the ssb pci
> core config options and enables only the needed ones.

Nack. Switch to b43. bcm43xx is going to be removed anyway.
I'm not going to play these kconfig SELECT tricks anymore.
We had _lots_ of bugs there. People submitted patches that
obviously looked OK and still they turned out to break
some dependencies. KConfig SELECT is a feature from hell.

-- 
Greetings Michael.
