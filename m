Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYH0LDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYH0LDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYH0LDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:03:17 -0400
Received: from fw-sth.ingate.se ([62.181.225.250]:63352 "EHLO
	kokeicha.ingate.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753465AbYH0LDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:03:16 -0400
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 07:03:16 EDT
Message-ID: <48B52E8C.40605@ingate.com>
Date: Wed, 27 Aug 2008 12:38:04 +0200
From: Marcus Sundberg <marcus@ingate.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: r8169 regression in 2.6.26.3 vs 2.6.26.2
References: <1219828800.30098.7.camel@plop>
In-Reply-To: <1219828800.30098.7.camel@plop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (kokeicha.ingate.se [10.48.254.3]); Wed, 27 Aug 2008 12:38:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> Since updating to 2.6.26.3, networking no longer works on Acer Aspire
> One.
> 
> PCI config is now always filled with ones.
> 
> Reverting "r8169: avoid thrashing PCI conf space above
> RTL_GIGA_MAC_VER_06" makes it work again.
> 
> The device is 10ec:8136

Ok, that's obviously not good. I checked the Realtek driver for
8101E (version r8101-1.009.00) and while it doesn't do any
8-bit writes to register 0x82 it does perform 32-bit writes to
register 0x80 (EPHYAR) to communicate with the PHY. I have no
idea what that 8-bit write does except it breaks the chipset in
my LG P300...

How does the kernel identify your chipset upon driver load?
(grep for XID)

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
