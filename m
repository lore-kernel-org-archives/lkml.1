Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbYDYRc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbYDYRc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764628AbYDYRcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:32:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:52221 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYDYRcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:32:42 -0400
Message-ID: <481215B7.9020503@windriver.com>
Date: Fri, 25 Apr 2008 12:32:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb over ethernet?
References: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Apr 2008 17:32:34.0477 (UTC) FILETIME=[58F86DD0:01C8A6FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
>
>
> the DocBook files for the recently-merged kgdb mention kgdboe, as does 
> the doc on kgdb.sf.net, but I do not see kgdboe anywhere in the source. 
> Is oe actually merged? I'm kinda short on rs232...
>   
Well if you have at least one you have enough because you can share kgdb
with the console.

> thanks,
> Jan
>   

kgdboe is not in the mainline kernel. 

It is a feature that might end up being re-implemented at some point or
perhaps merged as is in the future.  The current kgdboe suffers from
some reliability problems related to the need to sync interrupts prior
to using the network device hardware.  This is due to the way the
"polled mode" support is implemented in the NET POLL API.  There is
presently no good means to avoid certain deadlock scenarios.

That being said if you want to work with the latest kgdb + the latest
kernel work it is available.  First you clone Linus's tree and then do
something like:

git remote add kgdb-next
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
git remote update
git checkout kgdb-next

And later when if you update it, you would want make sure and use the
"+" type pull because the branch gets shuffled quite often with patches
pulled in and out of the tree.  IE:

git pull kgdb-next +kgdb-next:kgdb-next

Jason.
