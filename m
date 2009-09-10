Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbZIJPhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbZIJPhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZIJPhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:37:00 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:59861 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZIJPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:37:00 -0400
Date: Thu, 10 Sep 2009 17:37:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Johan van Baarlen" <vanbaajf@xs4all.nl>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Abbott" <michael@araneidae.co.uk>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johan van Baarlen" <jf@vanbaarlen.demon.nl>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090910173700.5e5fc3f8@skybase>
In-Reply-To: <2f08a48107b19501ffa2c1570483544f.squirrel@webmail.xs4all.nl>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
	<20090908225858.04d56dce.akpm@linux-foundation.org>
	<2f08a48107b19501ffa2c1570483544f.squirrel@webmail.xs4all.nl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 15:02:53 +0200
"Johan van Baarlen" <vanbaajf@xs4all.nl> wrote:

> with this patch the idle-time in /proc/uptime makes a lot more sense - but
> it runs about a factor of 4 too fast (I'm thinking this is not coincidence
> - I've got 4 cpu's in this box, and simply adding 4 idle timers means you
> are going 4 times too fast).
> 
> Can we just add idletime /= (i+1) after the foreachcpu loop, or am I
> thinking too easy?

With "/= (i+1)" you mean dividing the result by the number of cpus, no?
That doesn't work because of that fact that the value used to contain
the accumulated idle time of a uni-processor system and cpu hotplug.
The only way to get meaningful numbers is to make the value contain the
sum of the idle over all possible cpus. The user space tool that reads
the value needs to take the number of currently active cpus into
account.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

