Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYD2X1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYD2X1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYD2X1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:27:13 -0400
Received: from lixom.net ([66.141.50.11]:39415 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYD2X1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:27:13 -0400
Date: Tue, 29 Apr 2008 18:40:50 -0500
From: Olof Johansson <olof@lixom.net>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25+: Fix cpu hotplug in softirq code
Message-ID: <20080429234050.GA17936@lixom.net>
References: <200804242113.11602.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804242113.11602.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 09:13:11PM +0200, Christian Borntraeger wrote:
> Hello Olof,
> 
> currently cpu hotplug (unplug) seems broken on s390 and likely others. On cpu 
> unplug the system starts to behave very strange and hangs.
> 
> I bisected the problem to the following commit:
> 
> -----
> commit 48f20a9a9488c432fc86df1ff4b7f4fa895d1183
> Author: Olof Johansson <olof@lixom.net>
> Date:   Tue Mar 4 15:23:25 2008 -0800
>     tasklets: execute tasklets in the same order they were queued
> -----
> 
> Reverting this patch seems to fix the problem. I looked into takeover_tasklet
> and it seems that there is a way to corrupt the tail pointer of the current 
> cpu. If the tasklet list of the frozen cpu is empty, the tail pointer of the
> current cpu points to the address of the head pointer of the stopped cpu and 
> not to the next pointer of a tasklet_struct.
> 
> This patch avoids the list splice of the list is empty and cpu hotplug seems
> to work as the tail pointer is not corrupted.
> Olof, can you look into that patch and ACK/NACK it so Andrew can push this to
> Linus, if appropriate?
> Please note that some lines are longer than 80 chars, but line-wrapping looked
> worse that this version.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

I don't have a hotplug-capable system to test on, but the patch looks
good to me. Good catch.

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
