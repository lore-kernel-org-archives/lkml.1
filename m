Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYBXQ1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYBXQ1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYBXQ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:26:56 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33938 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYBXQ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:26:55 -0500
Message-ID: <47C19ABA.4040904@lwfinger.net>
Date: Sun, 24 Feb 2008 09:26:34 -0700
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
CC: Stefano Brivio <stefano.brivio@polimi.it>, Jeff Garzik <jgarzik@pobox.com>,
       Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       linux-kernel@vger.kernel.org, John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
References: <47C01D03.9030601@gmail.com>
In-Reply-To: <47C01D03.9030601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Zaytsev wrote:
> 
> [resent with lkml added to cc, sorry]
> 
> Hello, gentlemen.
> 
> Theese two patches fix a problem instroduced in Linux 2.6.24, and
> still present in the current Linus' 2.6.25 tree.
> 
> The bcm43xx Wifi driver won't work any more, if the b44 Ethernet
> driver is enabled. This happens because the b44 driver
> needlessly enables the b43_pci_bridge code, which claims
> the same pci ids as the bcm43xx driver. The b43_pci_bridge
> code is needed for the b43{legacy} drivers, but for the
> b44, only the "ssb pci core" is needed.
> 
> The first patch separates the ssb b43 pci bridge and the ssb pci
> core config options and enables only the needed ones.
> 
> A similar patch was once sent to Michael Buesch, but he rejected
> it, fearing that changing the config autoselects cold introduce
> some unexpected bugs.
> If you are intrested, a rather emotional thread may be found
> e.g. here:
> http://thread.gmane.org/gmane.linux.kernel/644266
> 
> That said, I believe the patch may introduce no more bugs,
> but fixes a critical regression, which left some users
> without a working wifi driver on the 2.6.24 kernel.
> 
> If you doubt its correctness, I may write a longer description
> on the changes introduced, but I hope they should be obvoius.
> 
> This patch is againts the current Linus' tree. I'd like it
> to be added to both 2.6.25 and the 2.6.24-stable trees.
> 
> The second patch disables the bcm43xx driver if it can't
> work due to the b43/b43legacy drivers inclusion, so no
> users should be confused.

I have reviewed the above patches and tested them with what I believe to be most combinations. 
Everything worked and corrected the unintended consequence of breaking bcm43xx when b44 is included. 
I agree that these patches belong in 2.6.25 and stable (2.6.24). Of course, the problem goes away in 
2.6.26.

ACKED-by: Larry.Finger@lwfinger.net

Larry

