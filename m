Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZKFNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZKFNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZKFNAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:00:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43930 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbZKFNAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:00:46 -0500
Message-ID: <4AF41DF0.7050002@us.ibm.com>
Date: Fri, 06 Nov 2009 07:00:32 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Amit Shah <amit.shah@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@linux-foundation.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports
 for generic guest and host communication
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com> <200911061740.03734.rusty@rustcorp.com.au> <200911060900.49923.borntraeger@de.ibm.com>
In-Reply-To: <200911060900.49923.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> I know that Anthony disagrees, but _If we start over_, I still think we should 
> use that chance and leave the old virtio console untouched and add a new driver 
> for the host guest communication. IMHO it turned out that there is only a tiny 
> bit of commonality. (most code pathes check for use_multiport and  then do two 
> completely different things).
> I like simplicity. According to David A. Wheeler's SLOCCount, the old console 
> has 141 lines of code and the I truly believe that a separate guest-host comm 
> vehicle would also be a lot simpler if it must not take care of the old 
> virtio_console interface.
>   

It's the wrong metrics for evaluating a device ABI.  We should consider 
device ABIs based on whether they make sense--not about how many lines 
of code it takes to implement the Linux driver.

Fundamentally speaking, right now, virtio-console is a single stream 
that acts as an interactive terminal.  What we're looking to add here is 
to support multiple terminals that can be enumerated in a rationale way.

I see no reason why that should be two separate devices.

> On the other hand we all should agree on one driver vs. two drivers before we go 
> on. Everything else would be unfair to Amit, who had the unpleasant task to 
> implement conflicting review comments....
>   

I agree and there are multiple maintainers on the qemu side who feel the 
same way I do.  I'm really strongly opposed to making this separate devices.

If you think it's easier, you can do a check in the virtio_probe 
function that checks for the feature bits and calls a completely 
separate virtio initialization routine so it ends up being two separate 
files in Linux.  But that's a Linux implementation detail.

> Christian
>   


-- 
Regards,

Anthony Liguori

