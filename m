Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZIJQ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZIJQ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZIJQ2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:28:08 -0400
Received: from araneidae.co.uk ([62.3.233.233]:51655 "EHLO
	venus.araneidae.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbZIJQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:28:06 -0400
Date: Thu, 10 Sep 2009 17:27:57 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Johan van Baarlen <vanbaajf@xs4all.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johan van Baarlen <jf@vanbaarlen.demon.nl>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <20090910173700.5e5fc3f8@skybase>
Message-ID: <alpine.DEB.1.10.0909101725130.25913@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk> <20090908225858.04d56dce.akpm@linux-foundation.org> <2f08a48107b19501ffa2c1570483544f.squirrel@webmail.xs4all.nl>
 <20090910173700.5e5fc3f8@skybase>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, Martin Schwidefsky wrote:
> On Thu, 10 Sep 2009 15:02:53 +0200
> "Johan van Baarlen" <vanbaajf@xs4all.nl> wrote:
> > with this patch the idle-time in /proc/uptime makes a lot more sense - but
> > it runs about a factor of 4 too fast (I'm thinking this is not coincidence
> > - I've got 4 cpu's in this box, and simply adding 4 idle timers means you
> > are going 4 times too fast).
> > 
> > Can we just add idletime /= (i+1) after the foreachcpu loop, or am I
> > thinking too easy?
> 
> With "/= (i+1)" you mean dividing the result by the number of cpus, no? 
> That doesn't work because of that fact that the value used to contain 
> the accumulated idle time of a uni-processor system and cpu hotplug. The 
> only way to get meaningful numbers is to make the value contain the sum 
> of the idle over all possible cpus. The user space tool that reads the 
> value needs to take the number of currently active cpus into account.

I've never liked this solution, as it's hugely unfriendly and requires 
access to detailed information which user space doesn't necessarily have: 
how is any particular user space application supposed to know the detailed 
history of cpu hotplug insertion and removal to accurately compute the 
idle time?

On the other hand, I don't have an alternative to suggest...
