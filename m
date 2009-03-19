Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbZCTAQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbZCTAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZCTAQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:16:06 -0400
Received: from kroah.org ([198.145.64.141]:47144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080AbZCTAQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:16:06 -0400
Date: Thu, 19 Mar 2009 16:51:14 -0700
From: Greg KH <greg@kroah.com>
To: Corey Minyard <minyard@acm.org>
Cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] limit CPU time spent in kipmid
Message-ID: <20090319235114.GA18182@kroah.com>
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2B994.7040808@acm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 04:31:00PM -0500, Corey Minyard wrote:
> Martin, thanks for the patch.  I had actually implemented something like 
> this before, and it didn't really help very much with the hardware I had, 
> so I had abandoned this method.  There's even a comment about it in 
> si_sm_result smi_event_handler(). Maybe making it tunable is better, I 
> don't know.  But I'm afraid this will kill performance on a lot of systems.
>
> Did you test throughput on this?  The main problem people had without 
> kipmid was that things like firmware upgrades took a *long* time; adding 
> kipmid improved speeds by an order of magnitude or more.
>
> It's my opinion that if you want this interface to work efficiently with 
> good performance, you should design the hardware to be used efficiently by 
> using interrupts (which are supported and disable kipmid).  With the way 
> the hardware is defined, you cannot have both good performance and low CPU 
> usage without interrupts.
>
> It may be possible to add an option to choose between performance and 
> efficiency, but it will have to default to performance.

I would think that very infrequent things, like firmware upgrades, would
not take priority over a long-term "keep the cpu busy" type system, like
what we currently have.

Is there any way to switch between the different modes dynamically?

I like the idea of this change, as I have got a lot of complaints lately
about kipmi taking way too much cpu time up on idle systems, messing up
some user's process accounting rules in their management systems.  But I
worry about making it a module parameter, why can't this be a
"self-tunable" thing?

thanks,

greg k-h
